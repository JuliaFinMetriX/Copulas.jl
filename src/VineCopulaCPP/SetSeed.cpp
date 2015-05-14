#include "VineCopulaCPP_header.hpp"

int main(){
  boost::mt19937 gen;
  gen.seed(time(0));
  
  // Save the state
  std::ofstream fo(PathSeed, 
		   std::ios_base::out);
  fo<<gen;
  fo.close();
  
  return 0;  
}
