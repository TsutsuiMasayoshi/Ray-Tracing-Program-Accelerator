using namespace std;

typedef union inst_t {
    uint32_t inst_32;
    struct rtype {

        unsigned long long int r4: 6,r3: 5,r2 : 5,r1: 5,r0: 5,op:6,non:28;
    }rtype;
    struct itype
    {
        unsigned long long int imm : 16,r1:5,r0: 5,op:6,non:28;
    }itype;
    struct jtype
    {
        unsigned long long int r0: 26,op:6,non:28;
    }jtype;
}inst_t;

typedef union myfloat {
    float f;
    int32_t i;
} myfloat;


int32_t Memory[1024*10000];// memory

string Registers[32]; //array to store names of registers
int32_t RegisterValues[32]; //array to store values of CPU registers
float FPURegisterValues[96];//array to store values of FPU registers
// float FPUImmediateValues[64];//array to store values of FPU Immediate registers
int32_t r[4]; //to store the id of operand or constant


// int Register_record[32];
// int FPU_Register_record[32];

int Memory_record[630000];
int Memory_Value_record[630000];
int Memory_Change_record[630000];
int Jal_record[11000];

int32_t ProgramCounter;
long long count_exec;
long long int limit_of_exec;
int32_t NumberOfInstructions; //to store the number of lines in the program

int max_memory_index;
// long long count_outc;

const int INSTRUCTION_NUM = 51;
int Instruction_count [INSTRUCTION_NUM];
string Instructions [INSTRUCTION_NUM];

std::fstream myfile;
std::fstream myfile2;
std::fstream print_register;
// std::fstream print_register2;
std::fstream print_analysis;
std::fstream print_lw;
std::fstream InputFile;
vector<inst_t> InputProgram3;


// string current_instruction;
inst_t current_instruction;
// unsigned int current_instruction2;



int32_t Instruction_op;
int32_t Instruction_funct;

// int32_t mode;
string fileName;
string fileName2;
int32_t num_input;
int32_t Mode; //to store the Mode of execution
int inputFileCheck;
