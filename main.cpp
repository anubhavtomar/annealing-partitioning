#include <iostream>
#include <vector>
#include <cstdlib>
#include <time.h>
#include <algorithm>
#include <math.h>
#include <fstream>
#include <iomanip>
#include <string>
#include <sstream>

using namespace std;

//global variables
int lines; //first line of telling how many nodes are in text 

struct NodeInfo
{
	int NodeNum;
	int CL_Software;
	int CL_Hardware;
	int CI_Flash;	
	int CI_Mac;	
	vector<int> NodeEdges;
};

NodeInfo *Curr_Solution;
NodeInfo *New_Solution;

vector<int> hardware_nodes;
vector<int> software_nodes;

vector<int> best_hardware_nodes;
vector<int> best_software_nodes;

void GetData()
{
	string line;
	ifstream f;
	f.open("fft-asm.txtprocess-graph.txt", ios::in);
	f.seekg(0);
	getline(f, line);
	string::size_type sz;	
	lines = stoi(line, &sz);
	Curr_Solution = new NodeInfo[lines];
	for (int i = 0; i < lines; i++)
	{
		getline(f, line);
		istringstream iss(line);
		string word;
		iss>>word;
		Curr_Solution[i].NodeNum = stoi(word, &sz);
		software_nodes.push_back(Curr_Solution[i].NodeNum);
		iss>>word;
		Curr_Solution[i].CL_Software = stoi(word, &sz);
		iss>>word;
		Curr_Solution[i].CL_Hardware = stoi(word, &sz);
		iss>>word;
		Curr_Solution[i].CI_Flash = stoi(word, &sz);
		iss>>word;
		Curr_Solution[i].CI_Mac = stoi(word, &sz);
		while(iss>>word)
		{
			int edges;
			edges = stoi(word);
			Curr_Solution[i].NodeEdges.push_back(edges);
		}
	}
	f.close();
}

void displayOutput(int lines)
{
	//display all names in formatted output
	cout<<endl;
	for (int i = 0; i < lines; i++) {
		cout << " Node Number:" << Curr_Solution[i].NodeNum <<endl;
		cout << " CL_Software:" << Curr_Solution[i].CL_Software<<endl;
		cout << " CL_Hardware:" << Curr_Solution[i].CL_Hardware<<endl;
		cout << " CI_Flash :" << Curr_Solution[i].CI_Flash<<endl;
		cout << " CI_Mac :" << Curr_Solution[i].CI_Mac<<endl;
		cout << " NodeEdges:";
		for(int k=0;k<Curr_Solution[i].NodeEdges.size();k++)
		{
			cout<<" ("<<Curr_Solution[i].NodeNum<<", "<<Curr_Solution[i].NodeEdges[k]<<")";
		}
		cout<<"\n\n";
	}
}

int CalculateCostFunct(int lines)
{
    float Q1 = 1, Q2 = 0.01, Q3 = 1;
    int wd_mac = 8, ci_mac = 4, mac_lim=0;
    int wd_flash = 512, ci_flash = 1, flash_lim = 0;
    int k = 0, j = 0, l = 0, m=0, n=0;
    float total_mac = 0, total_flash = 0;
    long long cost = 0;
    int CL_Hardware_sum = 0, CL_Software_sum = 0;

    //mac
    //lines has to change here
    //1/mac has to be verrified 
    
    for (n = 0; n < lines; n++) {
        if (Curr_Solution[n].CI_Mac != 0) {
            mac_lim++;
        }
    }
  
//   cout<<"mac_lim: "<<mac_lim<<endl; //Debug
    
    for (k = 0; k < mac_lim; k++) {
    	
        	total_mac += wd_mac / ci_mac;
    }
        
//    cout <<"total_mac: "<< total_mac << endl; //debug


    
	
    //flash
    for (j = 0; j < lines; j++) {
        total_flash += wd_flash * Curr_Solution[j].CI_Flash;
  //      cout<<"CI_Flash: "<<Curr_Solution[j].CI_Flash<<endl;
    }
    
//    cout << "total_flash : "<<total_flash << endl; //debug
  
    int hw_loop_limit = hardware_nodes.size();
    int sw_loop_limit = software_nodes.size();
    //HW nodes
    for (l = 0; l < hw_loop_limit; l++) {
        CL_Hardware_sum += Curr_Solution[hardware_nodes[l]].CL_Hardware;
        //cout << " CL_Hardware_sumALEX:" << CL_Hardware_sum << endl; //debug
    }
    
    if (hw_loop_limit != 0)		
    {		
        CL_Hardware_sum = CL_Hardware_sum / hw_loop_limit;		
    }
    
 //   cout<<"CL_Hardware_sum: "<<CL_Hardware_sum<<endl;

    //SW nodes
  //  cout<<"sw_loop_limit: "<<sw_loop_limit<<endl;//Debug
  
    for (m = 0; m < sw_loop_limit; m++) {
        CL_Software_sum += Curr_Solution[software_nodes[m]].CL_Software;
        
    }
    
  //  cout << " CL_Software_sumALEX:" << CL_Software_sum << endl; //debug
    
    
    if (sw_loop_limit != 0)		
    {		
        CL_Software_sum = CL_Software_sum / sw_loop_limit;		
    }
    
    /*
    cout << " total_mac" << total_mac << endl; //debug
    cout << " flash_lim" << flash_lim << endl; //debug
    cout << " total_flash:" << total_flash << endl; //debug
    cout << " CL_Software_sum:" << CL_Software_sum << endl; //debug
    cout << " CL_Hardware_sum:" << CL_Hardware_sum << endl; //debug
    */

    //cost = /*(Q1 * total_mac) + (Q1 * total_flash) */- (Q3 * (CL_Hardware_sum - CL_Software_sum));//debug
    cost = (Q1 * total_mac) + (Q2 * total_flash) - (Q3 * (CL_Hardware_sum - CL_Software_sum));

//    cout <<endl<< "COST:" << cost; //debug
                                        //cost = total_mac;

    return cost;

}


float ti = 1000;		//Step 2
float tl = 90;
float alpha = 0.96;
	
int random_number;
int curr_cost, new_cost, cost_difference, best_cost, worst_cost=0;
	
void SA_Algorithm()
{
	float t=ti;
	vector<int>::iterator it;
	curr_cost = CalculateCostFunct(lines);
	worst_cost = curr_cost;
	cout<<endl<<"Worst cost: "<<worst_cost<<endl;
	for(int i=0;i<software_nodes.size();i++)		//Printing out
		{
			cout<<software_nodes[i]<<" ";
		}	
		cout<<endl<<endl;
		cout<<"Hardware node: ";
		for(int i=0;i<hardware_nodes.size();i++)
		{
			cout<<hardware_nodes[i]<<" ";
		}
	best_cost = curr_cost;
	worst_cost = curr_cost;
	float q, equ;
	int flag, stopping_criteria_count=0;
	srand(time(NULL));
	while(t>tl)		
	{
		random_number = rand() % lines;		//Inner step in 3.1.1
		
		it = find(software_nodes.begin(), software_nodes.end(), random_number);
		if(it == software_nodes.end())		//if random number is not in software_nodes because it = software.end()
		{
			software_nodes.push_back(random_number);
			hardware_nodes.erase(remove(hardware_nodes.begin(), hardware_nodes.end(), random_number), hardware_nodes.end());
			flag = 1;		
		}
		else
		{
			hardware_nodes.push_back(random_number);
			software_nodes.erase(remove(software_nodes.begin(), software_nodes.end(), random_number), software_nodes.end());
		}
		
		new_cost = CalculateCostFunct(lines);
	//	cout<<"\n\nNew cost: "<<new_cost<<"\n"; //Debug
		cout<<endl<<new_cost;
		cost_difference = new_cost - curr_cost;		//Inner step 3.1.2
		if(new_cost < best_cost)
			{
				best_cost = new_cost;
				best_software_nodes.clear();
				for(int k=0;k<software_nodes.size();k++)
					best_software_nodes.push_back(software_nodes[k]);
					
				best_hardware_nodes.clear();
				for(int a=0;a<hardware_nodes.size();a++)
					best_hardware_nodes.push_back(hardware_nodes[a]);
				
			}
			
		
		if(new_cost > worst_cost)
			worst_cost = new_cost;
		
		if(cost_difference > 0)			//Inner step 3.1.3
		{
			q = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
			equ = exp(-cost_difference/t);
			if(q>=equ)		//Inner step 3.1.4
			{
				if(flag == 0)
				{
					software_nodes.push_back(random_number);
					hardware_nodes.erase(remove(hardware_nodes.begin(), hardware_nodes.end(), random_number), hardware_nodes.end());
				}
				else
				{
					hardware_nodes.push_back(random_number);
					software_nodes.erase(remove(software_nodes.begin(), software_nodes.end(), random_number), software_nodes.end());
				}
			}
		}
		else
			curr_cost = new_cost;
		
		//Print out every iteration of Hardware-Software vectors//Debug
	//	cout<<"\n\nNode change: "<<random_number<<"\n\n";
	/*	cout<<"Software node: "; 
		for(int i=0;i<software_nodes.size();i++)		//Printing out
		{
			cout<<software_nodes[i]<<" ";				//Debug
		}	
		cout<<endl<<endl;
		cout<<"Hardware node: ";
		for(int i=0;i<hardware_nodes.size();i++)
		{
			cout<<hardware_nodes[i]<<" ";
		}*/
		t = alpha * t;		//Step 3.2
		
	}
	cout<<endl<<endl<<"Best cost: "<<best_cost<<endl;
/*	cout<<"Software nodes: ";
	for(int i=0;i<best_software_nodes.size();i++)		//Printing out
		{
			cout<<best_software_nodes[i]<<" ";			//Debug
		}	
		cout<<endl<<endl;
		cout<<"Hardware node: ";
		for(int i=0;i<best_hardware_nodes.size();i++)
		{
			cout<<best_hardware_nodes[i]<<" ";
		}
		cout<<"\n\n";*/
//	cout<<endl<<"Worst cost: "<<worst_cost<<endl;
}


int main()
{

	GetData();
	SA_Algorithm();
	
	return 0;
}
	