#include <iostream>
#include <stdlib.h>
#include <cmath>
#include <cstring>
#include <fstream>
#include <vector>
#include <algorithm>
#include <sys/time.h>
#include "fpu_imitate.h"
#include "MyType.cpp"
#include "Instruction.cpp"
#include "ParseAndExecute.cpp"

using namespace std;

void init(){
    NumberOfInstructions=0;
    count_exec = 0;
    ProgramCounter=0;
    string tempRegisters[]={
    "zero", //0
    "at",
    "v0",
    "v1",
    "a0",//4
    "a1",
    "a2",
    "a3",
    "t0", //8
    "t1",
    "t2",
    "t3",
    "t4",
    "t5",
    "t6",
    "t7",
    "s0",//16
    "s1",
    "s2",//18
    "s3",
    "s4",
    "s5",
    "s6",
    "s7",
    "t8",
    "t9",
    "k0",
    "k1",
    "gp",
    "sp",
    "s8",
    "ra"
    }; //names of registers

    string tempInstructions[]={
    "add",  //0
    "sub ",
    "jr",
    "slt",
    "sll",
    "srl",
    "j",
    "jal",
    "beq",
    "bne",
    "addi",
    "slti",
    "ori",
    "lui",
    "fadd",
    "fsub",
    "fmul",
    "fdiv", //17
    "fsqrt",
    "floor",
    "ftoi",
    "itof",
    "fless",
    "ceqs",
    "mtc1",
    "lw",
    "sw",
    "lwc1",
    "swc1",
    "readf",
    "readi",
    "outc",
    "outi",
    "fori", //33
    "flui", //34
    "bslt",
    "bslti",
    "bfless",
    "bfeq",
    "bflessi",
    "bflessi2", //40
    "bflessi3",
    "bflessi4",
    "fori2",
    "flui2",
    "bnei",
    "bslti2",
    "lwc2",
    "swc2",
    "lw2",
    "sw2"
};

    if(num_input == 0){
        limit_of_exec = 10000000000;
    }else{
        limit_of_exec = num_input;
    }

    for(int32_t i=0;i<32;i++)
    {
        Registers[i]=tempRegisters[i];
    }

    for(int32_t i=0;i<INSTRUCTION_NUM;i++)
    {
        Instructions[i]=tempInstructions[i];
    }

    for(int32_t i=0;i<32;i++)
    {
        RegisterValues[i]=0;
    }
    for(int32_t i=0;i<64;i++)
    {
        FPURegisterValues[i] = 0.0;
    }

    for(int32_t i=0;i<1024*10000;i++)
    {
        Memory[i]=0;
    }


    for(int32_t i=0;i<630000;i++)
    {
        Memory_record[i]=0;
        Memory_Value_record[i]=0;
        Memory_Change_record[i]=0;
    }

    for(int32_t i=0;i<11000;i++)
    {
        Jal_record[i]=0;
    }


    for(int32_t i=0;i<INSTRUCTION_NUM;i++)
    {
        Instruction_count[i]=0;
    }

    ifstream InputFile;
    InputFile.open(fileName.c_str(),ios::in);

    if(!InputFile)
    {
        cout<<"Error: File does not exist or could not be opened"<<endl;
        exit(1);
    }

    string tempString;
    unsigned long long int tempInt;
    inst_t tempInst;

    while(getline(InputFile,tempString))
    {
        NumberOfInstructions++;
        tempInt = strtoull(tempString.substr(0,32).c_str(), nullptr, 2);
        //InputProgram2にpush
        tempInst.inst_32 = tempInt;
        InputProgram3.push_back(tempInst);
    }
    InputFile.close();


}

void PrintRegister()
{
    print_register<<"begin"<<endl;
    for (int i = 0; i <= 31; i++){
        if(RegisterValues[i] != 0){
            print_register<<Registers[i]<<": "<<RegisterValues[i]<<"(" << std::hex << RegisterValues[i] << ")" << std::dec << " | ";
        }
    }
    for (int i = 0; i <= 31; i++){
        if (FPURegisterValues[i] != 0.0){
            print_register<<"$f"<<i<<": "<<FPURegisterValues[i]<<"(" << std::hex << FPURegisterValues[i] << ")" << std::dec << " | ";
        }

    }
    for (int i = 32; i <= 95; i++){
        if (FPURegisterValues[i] != 0.0){
            print_register<<"$fi"<<(i-32)<<": "<<FPURegisterValues[i]<<"(" << std::hex << FPURegisterValues[i] << ")" << std::dec << " | ";
        }
    }
    // for (int i = 4070; i<=4096; i++){
    //     print_register<<"Memory"<<i<<"  :"<<Memory[i]<<endl;
    // }
}

/*set current_instruction*/
void ReadInstruction(int32_t program_counter)
{
    current_instruction = InputProgram3[program_counter];
}



void execute()
{

    getchar(); //to remove effect of pressing enter key while starting
    long long prev_pc = -1;


    myfile.open ("print_output.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);

    myfile2.open("result.ppm", std::fstream::in | std::fstream::out | std::fstream::trunc);
    // // print_pc.open ("print_pc.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);

    print_register.open ("print_register.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);
    // // print_register2.open ("print_register2.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);
    // puts("8");
    print_analysis.open("print_analysis.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);
    // print_lw.open("print_lw.txt", std::fstream::in | std::fstream::out | std::fstream::trunc);

    unsigned int sec;
    int nsec;
    double d_sec;

    struct timespec start_time, end_time;
    clock_gettime(CLOCK_REALTIME, &start_time);

    while(prev_pc!= ProgramCounter && ProgramCounter<NumberOfInstructions && count_exec<limit_of_exec)
    {
        // cout<<ProgramCounter<<endl;
        prev_pc = ProgramCounter;

        // auto start = chrono::steady_clock::now();
        ReadInstruction(ProgramCounter); //set current_instruction
        // auto end = chrono::steady_clock::now();
        // cout << "Elapsed time in read : "
        // << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
        // << " ns" << endl;

        // start = chrono::steady_clock::now();
        // ExecuteInstruction(); //call appropriate operation function based on the op and increment program counter
        ParseAndExecuteInstruction();
        // end = chrono::steady_clock::now();
        // cout << "Elapsed time in execute : "
        // << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
        // << " ns" << endl;

        if (count_exec%50000000==0 && count_exec != 0){
          cout<<"current_count_exec:"<<count_exec<<" PC: "<<ProgramCounter<<endl;
        }

        count_exec++;

        if(Mode == 0){
          print_register<<"count_exec:"<<count_exec<<endl;
          PrintRegister();
          print_register<<"***** PC after　execution: *****"<<ProgramCounter<<endl;
        }
    }

    clock_gettime(CLOCK_REALTIME, &end_time);
    sec = end_time.tv_sec - start_time.tv_sec;
    nsec = end_time.tv_nsec - start_time.tv_nsec;
    d_sec = (double)sec + (double)nsec/(1000 * 1000 * 1000);

    cout <<"*********end of execution**********"<< endl;
    cout << "time_consumed:"<< d_sec << endl;
    cout<<" execution_count: "<<count_exec<<endl;
    PrintRegister();

    /* print_analysis*/
    for (int i = 0; i <= 52; i++){
            if(Instruction_count[i]!=0){
                print_analysis<<Instructions[i]<<": "<<Instruction_count[i]<<endl;
            }
            
    }

    print_analysis<<"maximum index of memory being used:"<< max_memory_index <<endl;


    int memory_temp_value=0;
    int memory_lw_all=0;
    for (int i = 0; i < 630000; i++){
        if(Memory_record[i]!= 0){
            memory_lw_all += Memory_record[i];
            if(Memory_Change_record[i]== 0 || Memory_Change_record[i]== 1){
                memory_temp_value += Memory_record[i];
            }
        }
    }
    print_analysis<<"Memory changed only once: "<<memory_temp_value<<" Memory_all_lw: "<<memory_lw_all ;




    // for (int i = 0; i <= 11000; i++){
    //     if(Jal_record[i] != 0){
    //         print_analysis<<"ProgramCounter: "<<i<<" jal count: "<<Jal_record[i]<<endl;
    //     }
    // }

    // for (int i = 0; i <= 31; i++){
    //         print_analysis<<"Register "<<i<<" count: "<<Register_record[i]<<endl;
    //         print_analysis<<"FPU_Register "<<i<<" count: "<<FPU_Register_record[i]<<endl;
    // }

    myfile.close();
    myfile2.close();
    // print_analysis.close();
    // // myfile3.close();
    // // print_pc.close();
    print_register.close();
    // print_lw.close();

    // print_register2.close();
    if(inputFileCheck == 1){
        InputFile.close();
    }
}


int main()
{

    cout<<endl<<"MIPS Simulator - team7"<<endl<<endl;
    cout<<"入力形式： [binary file path] ＋ [実行行数]"<<endl;
    cout<<"入力例：  ./sample_binary.txt  5 "<<endl;
    cout<<"ただし、[実行行数]=0の場合は全ての命令を実行する。 "<<endl;
    cout<<">> ";
    cin>>fileName>>num_input;
    cout<<"Do you want to print registers by step? Enter 1 for yes, and 0 for no "<<endl;
    cout<<">> ";
    cin >> Mode;
    Mode = 1-Mode;
    cout<<"Do you have any input file? Enter 1 for yes, and 0 for no "<<endl;
    cout<<">> ";
    cin >> inputFileCheck;
    if(inputFileCheck == 1){
        cout<<"Please enter the path of input file"<<endl;
        cout<<">> ";
        cin>>fileName2;
        InputFile.open(fileName2.c_str(),ios::in);
        if(!InputFile)
        {
            cout<<"Error: Input file does not exist or could not be opened"<<endl;
            exit(1);
        }
        cout<<"Execution has started with input file."<<endl;
    }else{
        cout<<"Execution has started without input file."<<endl;
    }
    init();
    execute();
    return 0;
}
