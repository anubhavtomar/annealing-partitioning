#include <iostream>
#include <sstream>
#include <vector>
#include <cstdlib>
#include <time.h>
#include <fstream>
#include <iomanip>
#include <string>
#include <math.h>
#include <algorithm>

using namespace std;

int lines;

struct NodeInfo {
	int nodeNum;
	int CL_Software;
	int CL_Hardware;
	int CI_Flash;	
	int CI_Mac;	
	vector<int> nodeEdges;
};
NodeInfo *currSolution;
vector<int> hwNodes;
vector<int> swNodes;
vector<int> bestHwNodes;
vector<int> bestSwNodes;
vector<int> worstHwNodes;
vector<int> worstSwNodes;
void GetData() {
	string line;
	ifstream f;
	f.open("fft-asm.txt-process-graph.txt", ios::in);
	f.seekg(0);
	getline(f, line);
	string::size_type sz;	
	lines = stoi(line, &sz);
	currSolution = new NodeInfo[lines];
	for (int i = 0; i < lines; i++) {
		getline(f, line);
		istringstream iss(line);
		string word;
		iss>>word;
		currSolution[i].nodeNum = stoi(word, &sz);
		swNodes.push_back(currSolution[i].nodeNum);
		iss>>word;
		currSolution[i].CL_Software = stoi(word, &sz);
		iss>>word;
		currSolution[i].CL_Hardware = stoi(word, &sz);
		iss>>word;
		currSolution[i].CI_Flash = stoi(word, &sz);
		iss>>word;
		currSolution[i].CI_Mac = stoi(word, &sz);
	}
	f.close();
}

void displayOutput(int lines) {
	cout<<endl;
	for (int i = 0; i < lines; i++) {
		cout << " Node Number:" << currSolution[i].nodeNum <<endl;
		cout << " CL_Software:" << currSolution[i].CL_Software<<endl;
		cout << " CL_Hardware:" << currSolution[i].CL_Hardware<<endl;
		cout << " CI_Flash :" << currSolution[i].CI_Flash<<endl;
		cout << " CI_Mac :" << currSolution[i].CI_Mac<<endl;
		cout << " nodeEdges:";
	}
}

int CalculateCostFunct(int lines) {
    // float Q1 = 1, Q2 = 0.01, Q3 = 1;
    float Q1 = 1000, Q2 = 0.01, Q3 = 1;
    int wd_mac = 8, ci_mac = 4, mac_lim=0;
    int wd_flash = 512, ci_flash = 1, flash_lim = 0;
    int k = 0, j = 0, l = 0, m=0, n=0;
    float total_mac = 0, total_flash = 0;
    long long cost = 0;
    int CL_HardwareSum = 0, CL_SoftwareSum = 0;
    for (n = 0; n < lines; n++) {
        if (currSolution[n].CI_Mac != 0) {
            mac_lim++;
        }
    }
    for (k = 0; k < mac_lim; k++) {
    	total_mac += wd_mac / ci_mac;
    }
    for (j = 0; j < lines; j++) {
        total_flash += wd_flash * currSolution[j].CI_Flash;
    }
    int hwNodesLen = hwNodes.size();
    int swNodesLen = swNodes.size();
    for (l = 0; l < hwNodesLen; l++) {
        CL_HardwareSum += currSolution[hwNodes[l]].CL_Hardware;
    }
    if (hwNodesLen != 0)	{		
        CL_HardwareSum = CL_HardwareSum / hwNodesLen;		
    }
    for (m = 0; m < swNodesLen; m++) {
        CL_SoftwareSum += currSolution[swNodes[m]].CL_Software;
    }
    if (swNodesLen != 0)	{		
        CL_SoftwareSum = CL_SoftwareSum / swNodesLen;		
    }
    cost = (Q1 * total_mac) + (Q2 * total_flash) - (Q3 * (CL_HardwareSum - CL_SoftwareSum));
    return cost;
}
float TI = 1000;
float TL = 90;
float alpha = 0.98;	
int randomNumber;
int currCost, newCost, costDifference, bestCost, worstCost=0;
void annealingPartitioning() {
	float currentTemp = TI;
	vector<int>::iterator it;
	currCost = CalculateCostFunct(lines);
	int initCost = currCost;
	float q, equ;
	int flag, stopping_criteria_count=0;
	bool isChanged;
	int frozenCount;
	int steps;
	int differentSteps=7000;
	for(int li=1;li<=differentSteps;li++){
		currCost = initCost;
		worstCost = currCost;
		worstHwNodes = hwNodes;
		worstSwNodes = swNodes;
		bestCost = currCost;
		worstCost = currCost;
		stopping_criteria_count=0;
		srand(time(NULL));
		isChanged = false;
		frozenCount = 3;
		steps = li;
		while(steps--) {
			randomNumber = rand() % lines;
			it = find(swNodes.begin(), swNodes.end(), randomNumber);
			if(it == swNodes.end()) {
				swNodes.push_back(randomNumber);
				hwNodes.erase(remove(hwNodes.begin(), hwNodes.end(), randomNumber), hwNodes.end());
				flag = 1;		
			}
			else {
				hwNodes.push_back(randomNumber);
				swNodes.erase(remove(swNodes.begin(), swNodes.end(), randomNumber), swNodes.end());
			}
			newCost = CalculateCostFunct(lines);
			// cout<<"Cost: ";
			// cout<<newCost;
			costDifference = newCost - currCost;
			q = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
			equ = exp(-costDifference/currentTemp);
			if(costDifference > 0 && q >= equ)	{
				if(flag == 0) {
					swNodes.push_back(randomNumber);
					hwNodes.erase(remove(hwNodes.begin(), hwNodes.end(), randomNumber), hwNodes.end());
				} else {
					hwNodes.push_back(randomNumber);
					swNodes.erase(remove(swNodes.begin(), swNodes.end(), randomNumber), swNodes.end());
				}
				frozenCount--;
				isChanged = false;
			} else {
				isChanged = true;
				currCost = newCost;
				if(newCost < bestCost){
					bestCost = newCost;
					bestSwNodes.clear();
					for(int k=0;k<swNodes.size();k++) {
						bestSwNodes.push_back(swNodes[k]);
					}
					bestHwNodes.clear();
					for(int a=0;a<hwNodes.size();a++) {
						bestHwNodes.push_back(hwNodes[a]);
					}
				}
				if(newCost > worstCost) {
					worstCost = newCost;
				}
				frozenCount = 3;
			}
			if(!frozenCount && !isChanged) {
				break;
			}
			currentTemp = alpha * currentTemp;
			/*cout<<endl<<"Software Nodes: "<<endl;
			for(int i=0;i<swNodes.size();i++) {
				cout<<swNodes[i]<<" ";
			}	
			cout<<endl<<endl;
			cout<<"Hardware Nodes: "<<endl;
			for(int i=0;i<hwNodes.size();i++) {
				cout<<hwNodes[i]<<" ";
			}*/
			// cout<<swNodes.size()<<" ";
			// cout<<hwNodes.size()<<" ";
			// cout<<newCost<<" ";
			// cout<<endl;
			// cout<<endl<<"-----------------------"<<endl;
		}
		cout<<li<<" ";
		cout<<bestCost<<" ";
		cout<<endl;
	}
	cout<<endl<<endl;
	// cout<<endl<<"**************************"<<endl;
	// cout<<"Best cost: "<<bestCost<<endl;
	/*cout<<endl<<"Software Nodes: "<<endl;
	int nodesLen = bestSwNodes.size(); 
	for(int i = 0 ; i < nodesLen ; i++) {
		cout<<bestSwNodes[i]<<" ";
	}	
	cout<<endl<<endl;
	cout<<"Hardware Nodes: "<<endl;
	nodesLen = bestHwNodes.size(); 
	for(int i = 0 ; i < nodesLen ; i++) {
		cout<<bestHwNodes[i]<<" ";
	}
	cout<<endl<<"**************************"<<endl;*/

	cout<<endl<<endl;
	// cout<<endl<<"**************************"<<endl;
	// cout<<"Worst cost: "<<worstCost<<endl;
	/*cout<<endl<<"Software Nodes: "<<endl;
	nodesLen = worstSwNodes.size(); 
	for(int i = 0 ; i < nodesLen ; i++) {
		cout<<worstSwNodes[i]<<" ";
	}	
	cout<<endl<<endl;
	cout<<"Hardware Nodes: "<<endl;
	nodesLen = worstHwNodes.size(); 
	for(int i = 0 ; i < nodesLen ; i++) {
		cout<<worstHwNodes[i]<<" ";
	}
	cout<<endl<<"**************************"<<endl;*/
}

int main() {
	GetData();
	// displayOutput(54);
	annealingPartitioning();
	return 0;
}
	