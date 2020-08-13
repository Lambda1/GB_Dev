#include <iostream>
#include <fstream>
#include <vector>

int main(int argc, char *argv[])
{
	if(argc < 2) { std::cerr << "ERROR " << __LINE__ << std::endl; return 1; }
	
	std::ifstream rom_file(argv[1], std::ios::in | std::ios::binary);
	if(!rom_file) { std::cerr << "ERROR " << __LINE__ << std::endl;	return 1; }

	std::vector<char> rom_data;
	char data;
	while(!rom_file.eof())
	{
		rom_file.read(&data, sizeof(data));
		rom_data.emplace_back(data);
	}
	rom_file.close();
	
	int x = 0;
	for(int i = 0x0134;i <= 0x014C; ++i)
	{
		x = x - static_cast<int>(rom_data[i]) - 1;
	}
	std::cout << "Header CheckSum: $" << std::hex << (x & 0xff) << std::endl;
	
	int y = 0;
	for(auto itr = rom_data.begin();itr != rom_data.end();++itr)
	{
		y = y - static_cast<int>(*itr) - 1;
	}
	std::cout << "Global CheckSum: $" << std::hex << (y & 0xffff) << std::endl;


	return 0;
}
