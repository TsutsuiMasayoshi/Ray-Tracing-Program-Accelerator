using namespace std;
/*call appropriate operation function based on the op and increment program counter*/
void update_biggest(int a){
    if(a> max_memory_index){
        max_memory_index = a;
        // cout<<ProgramCounter<<","<<a <<"  ";
    }
}

// R-type : opcode   rs  rt  rd
void add()
{
    RegisterValues[r[2]]=RegisterValues[r[0]]+RegisterValues[r[1]];
    if(Mode == 0){
        print_register<<"add is executed"<<endl;
    }
}

void sub()
{
    RegisterValues[r[2]]=RegisterValues[r[0]]-RegisterValues[r[1]];
    if(Mode == 0){
        print_register<<"sub is executed"<<endl;
    }
}

void jr()
{
    ProgramCounter = RegisterValues[r[0]];
    if(Mode == 0){
        print_register<<"jr is called"<<endl;
    }
}

void slt()
{
    if(RegisterValues[r[0]]<RegisterValues[r[1]]){
        RegisterValues[r[2]] =1;
    }else{
        RegisterValues[r[2]] = 0;
    }
    if(Mode == 0){
        print_register<<"slt is executed"<<endl;
    }
}

void sll(){
    RegisterValues[r[2]]=RegisterValues[r[1]]<<r[3];
    if(Mode == 0){
        print_register<<"sll is executed"<<endl;
    }
}

void srl(){
    int32_t temp_a =  r[3];
    if(temp_a>0){
        RegisterValues[r[2]]=RegisterValues[r[1]]>>1;
        RegisterValues[r[2]]=RegisterValues[r[2]]&0b01111111111111111111111111111111;
        temp_a --;
        RegisterValues[r[2]]=RegisterValues[r[2]]>>temp_a;
    }

    if(Mode == 0){
        print_register<<"srl is executed"<<endl;
    }
}


// I-type : opcode   rs  rt  IMM
void addi()
{
    RegisterValues[r[1]]=RegisterValues[r[0]]+r[2];
    if(Mode == 0){
        print_register<<"addi is executed with Reg "<<r[1]<<" <- Reg "<< r[0]<<" + "<<  r[2] <<endl;
    }
}

void lui()
{
    RegisterValues[r[1]]= 0;
    RegisterValues[r[1]] = RegisterValues[r[1]] | (r[2]<<16);
    if(Mode == 0){
        print_register<<"lui is executed"<<endl;
    }
}

void ori()
{
    int temp_imm =  r[2] & 0b1111111111111111;
    RegisterValues[r[1]]=RegisterValues[r[0]] | temp_imm;
    if(Mode == 0){
        print_register<<"ori is executed"<<endl;
    }
}

void slti()
{
    if (RegisterValues[r[0]]<r[2]){
        RegisterValues[r[1]]=1;
    }else{
        RegisterValues[r[1]]=0;
    }

    if(Mode == 0){
        print_register<<"slti is executed"<<endl;
    }
}

void bne()
{
    if(RegisterValues[r[0]] != RegisterValues[r[1]]){
        ProgramCounter += r[2];
    }

    if(Mode == 0){
        print_register<<"bne is executed"<<endl;
    }
}

void beq()
{
    if(RegisterValues[r[0]] == RegisterValues[r[1]]){
        ProgramCounter += r[2];
    }

    if(Mode == 0){
        print_register<<"beq is executed with "<<RegisterValues[r[0]] << " and "<<RegisterValues[r[1]] <<endl;
    }
}

void lw2()
{
    int temp_addr = RegisterValues[(r[2] / 2048)]+RegisterValues[r[0]];
    update_biggest(temp_addr);
    RegisterValues[r[1]]= Memory[temp_addr];
    if(Mode == 0){
        print_register<<endl<<"lw2 is executed with value: "<< RegisterValues[r[1]] <<" address:  "<<temp_addr<<endl;
    }
}

void sw2()
{
    
    update_biggest(RegisterValues[(r[2] / 2048)]+RegisterValues[r[0]]);
    Memory[RegisterValues[r[0]]+RegisterValues[(r[2] / 2048)]] =  RegisterValues[r[1]];
    if(Mode == 0){
        print_register<<endl<<"sw2 is executed with value: "<<RegisterValues[r[1]]<<" address:  "<< RegisterValues[r[0]]+RegisterValues[(r[2] / 2048)]<<endl;
    }

}

void bslt()
{
    if(RegisterValues[r[0]] < RegisterValues[r[1]]){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bslt is executed "<<endl;
    }
}

// I-type
void bslti()
{
    if (RegisterValues[r[0]]<r[1]){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        //cout << r[1] << endl;
        print_register<<"bslti is executed"<<endl;
    }
}

void bslti2()
{
    if (r[0]<RegisterValues[r[1]]){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        //cout << r[1] << endl;
        print_register<<"bslti2 is executed"<<endl;
    }
}

void bnei()
{
    if (RegisterValues[r[0]]!=r[1]){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        //cout << r[1] << endl;
        print_register<<"bnei is executed"<<endl;
    }
}

void bfless(){
    if (myfless(FPURegisterValues[r[0]],FPURegisterValues[r[1]])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bfless is executed " <<endl;
    }
}

void bflessi(){
    if (myfless(FPURegisterValues[r[0]+32],FPURegisterValues[r[1]])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bflessi is executed  "  <<endl;
    }
}

void bflessi2(){
    if (myfless(FPURegisterValues[r[0]+64],FPURegisterValues[r[1]])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bflessi2 is executed" <<endl;
    }
}

void bflessi3(){
    if (myfless(FPURegisterValues[r[0]],FPURegisterValues[r[1]+32])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bflessi2 is executed" <<endl;
    }
}

void bflessi4(){
    if (myfless(FPURegisterValues[r[0]],FPURegisterValues[r[1]+64])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bflessi2 is executed" <<endl;
    }
}

void bfeq(){
    if (myfeq(FPURegisterValues[r[1]],FPURegisterValues[r[0]])){
        ProgramCounter += r[2];
    }
    if(Mode == 0){
        print_register<<"bfeq is executed " <<endl;
    }
}

void lw()
{
    int temp_addr = r[2]+RegisterValues[r[0]];
    update_biggest(temp_addr);
    RegisterValues[r[1]]= Memory[temp_addr];
    if(Mode == 0){
        print_register<<endl<<"lw is executed with value: "<< RegisterValues[r[1]] <<" address:  "<<temp_addr<<endl;
    }
    // Memory_record[temp_addr] += 1;

    // if(Memory_Value_record[temp_addr]!= RegisterValues[r[1]]){
    //     Memory_Value_record[temp_addr] = RegisterValues[r[1]];
    //     Memory_Change_record[temp_addr] += 1;
    // }


}


void sw()
{
    update_biggest(r[2]+RegisterValues[r[0]]);
    Memory[RegisterValues[r[0]]+r[2]] =  RegisterValues[r[1]];
    if(Mode == 0){
        print_register<<endl<<"sw is executed with value: "<<RegisterValues[r[1]]<<" address:  "<< RegisterValues[r[0]]+r[2]<<endl;
    }

}

// J type
void j()
{
    int32_t temp_a = ProgramCounter + 1;
    temp_a = temp_a & 0b11110000000000000000000000000000;
    int32_t temp_b = r[0];
    ProgramCounter = temp_a|temp_b;
    if(Mode == 0){
        print_register<<"j is called"  <<endl;
    }
}

void jal()
{
    RegisterValues[31] = ProgramCounter + 1;

    int32_t temp_a = ProgramCounter + 1;
    temp_a = temp_a & 0b11110000000000000000000000000000;
    // int32_t temp_b = r[0]*4;
    int32_t temp_b = r[0];
    ProgramCounter = temp_a|temp_b;
    // Jal_record[ProgramCounter/4] += 1;
    if(Mode == 0){
        print_register<<"jal is called"<<endl;
    }

}


/* FPU */
void fadd(){
    // if(r[3]==16){
        FPURegisterValues[r[2]] = myfadd(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
        if(Mode == 0){
            print_register<<"fadd is executed　with $f" <<r[1]<<"and $f"<<r[0]<<endl;
        }
    // }else if(r[3]==17){
    //     FPURegisterValues[r[2]] = myfadd(FPURegisterValues[r[1]+64],FPURegisterValues[r[0]]);
    //     if(Mode == 0){
    //         print_register<<"fadd with imm_1 is executed with $fi"<<r[1]<<"and $f"<<r[0]<<endl;
    //     }
    // }else if(r[3]==18){
    //     FPURegisterValues[r[2]] = myfadd(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
    //     if(Mode == 0){
    //         print_register<<"fadd with imm_2 is executed with $f"<<r[1]<<"and $fi"<<r[0]<<endl;
    //     }
    // }
}
void fsub(){

    // if(r[3]==16){
        FPURegisterValues[r[2]] = myfsub(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
        if(Mode == 0){
            print_register<<"fsub is executed"<<endl;
        }
    // }else if(r[3]==17){
    //     FPURegisterValues[r[2]] = myfsub(FPURegisterValues[r[1]+64],FPURegisterValues[r[0]]);
    //     if(Mode == 0){
    //         print_register<<"fsub with imm_1 is executed"<<endl;
    //     }
    // }else if(r[3]==18){
    //     FPURegisterValues[r[2]] = myfsub(FPURegisterValues[r[1]],FPURegisterValues[r[0]+64]);
    //     if(Mode == 0){
    //         print_register<<"fsub with imm_2 is executed"<<endl;
    //     }
    // }
    // if(Mode == 0){
    //     print_register<<"fsub is executed"<<endl;
    // }
}
void fmul(){
    // if(r[3]==16){
        FPURegisterValues[r[2]] = myfmul(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
        if(Mode == 0){
            print_register<<"fmul is executed"<<endl;
        }
    // }else if(r[3]==17){
    //     FPURegisterValues[r[2]] = myfmul(FPURegisterValues[r[1]+64],FPURegisterValues[r[0]]);
    //     if(Mode == 0){
    //         print_register<<"fmul with imm_1 is executed"<<endl;
    //     }
    // }else if(r[3]==18){
    //     FPURegisterValues[r[2]] = myfmul(FPURegisterValues[r[1]],FPURegisterValues[r[0]+64]);
    //     if(Mode == 0){
    //         print_register<<"fmul with imm_2 is executed"<<endl;
    //     }
    // }

}
void fdiv(){
    // if(r[3]==16){
        FPURegisterValues[r[2]] = myfdiv(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
        if(Mode == 0){
            print_register<<"fdiv is executed"<<endl;
        }
    // }else if(r[3]==17){
    //     FPURegisterValues[r[2]] = myfdiv(FPURegisterValues[r[1]+64],FPURegisterValues[r[0]]);
    //     if(Mode == 0){
    //         print_register<<"fdiv with imm_1 is executed"<<endl;
    //     }
    // }else if(r[3]==18){
    //     FPURegisterValues[r[2]] = myfdiv(FPURegisterValues[r[1]],FPURegisterValues[r[0]+64]);
    //     if(Mode == 0){
    //         print_register<<"fdiv with imm_2 is executed"<<endl;
    //     }
    // }
}
void fsqrt(){
    // FPURegisterValues[r[2]] =  sqrt(FPURegisterValues[r[1]]);
    FPURegisterValues[r[2]] = myfsqrt(FPURegisterValues[r[1]]);
    if(Mode == 0){
        print_register<<"fsqrt is executed"<<endl;
    }
}

void fless(){
    // if(FPURegisterValues[r[1]]<FPURegisterValues[r[0]]){
    //     RegisterValues[r[2]]=1;
    // }else{
    //     RegisterValues[r[2]]=0;
    // }
    RegisterValues[r[2]] = myfless(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
    if(Mode == 0){
        print_register<<"fless is executed with: if " <<FPURegisterValues[r[1]]<<"< "<< FPURegisterValues[r[0]] <<endl;
    }
}



void itof(){
    // FPURegisterValues[r[2]] = (float)RegisterValues[r[1]];
    FPURegisterValues[r[2]] = myitof(RegisterValues[r[1]]);
    if(Mode == 0){
        print_register<<"itof is executed with"<<FPURegisterValues[r[2]]<< endl;
    }
}

void ftoi(){
    // int temp_a = (int)FPURegisterValues[r[1]];
    // float temp_b =  abs(FPURegisterValues[r[1]]-temp_a);
    // if(temp_b >= 0.5){
    //     if(temp_a>0){temp_a += 1;}else{
    //         temp_a -= 1;
    //     }
    // }
    // RegisterValues[r[2]] = temp_a;
    RegisterValues[r[2]]= myftoi(FPURegisterValues[r[1]]);
    if(Mode == 0){
        print_register<<"ftoi is executed with"<<RegisterValues[r[2]]<< endl;
    }
}

void floor(){
    // if(FPURegisterValues[r[1]]>=0){
    //     RegisterValues[r[2]] = (int)FPURegisterValues[r[1]];
    // }else{
    //     RegisterValues[r[2]] = (int)FPURegisterValues[r[1]]-1;
    // }
    FPURegisterValues[r[2]] = myfloor(FPURegisterValues[r[1]]);
    if(Mode == 0){
        print_register<<"floor is executed with"<<RegisterValues[r[2]]<< endl;
    }
}
void ceqs(){
    // if(FPURegisterValues[r[1]]==FPURegisterValues[r[0]]){
    //     RegisterValues[r[2]]=1;
    // }else{
    //     RegisterValues[r[2]]=0;
    // }
    RegisterValues[r[2]] = myfeq(FPURegisterValues[r[1]],FPURegisterValues[r[0]]);
    if(Mode == 0){
        print_register<<"ceqs is executed"<<endl;
    }
}


void mtc1(){
    myfloat var;
    var.i = RegisterValues[r[0]];
    FPURegisterValues[r[1]] = var.f;
    // FPURegisterValues[r[1]]= int_to_binary_to_float(RegisterValues[r[0]]);
    if(Mode == 0){
        print_register<<"mtc1 is executed"<<endl;
    }
}

// register not sure
void fori(){
    int temp_imm =  r[2] & 0b1111111111111111;
    myfloat var;
    var.f = FPURegisterValues[r[0]+32];
    var.i = var.i | temp_imm;
    FPURegisterValues[r[1]+32]=var.f;
    if(Mode == 0){
        print_register<<"fori is executed"<<endl;
    }
}

void fori2(){
    int temp_imm =  r[2] & 0b1111111111111111;
    myfloat var;
    var.f = FPURegisterValues[r[0]+64];
    var.i = var.i | temp_imm;
    FPURegisterValues[r[1]+64]=var.f;
    if(Mode == 0){
        print_register<<"fori2 is executed"<<endl;
    }
}

void flui(){
    myfloat var;
    var.i = 0;
    var.i = var.i| (r[2]<<16);
    FPURegisterValues[r[1]+32] = var.f;
    if(Mode == 0){
        print_register<<"flui is executed"<<endl;
        print_register<<r[1]<<endl;
    }
}

void flui2(){
    myfloat var;
    var.i = 0;
    var.i = var.i| (r[2]<<16);
    FPURegisterValues[r[1]+64] = var.f;
    if(Mode == 0){
        print_register<<"flui2 is executed"<<endl;
    }
}

void lwc1(){
    update_biggest(r[2]+RegisterValues[r[0]]);
    // FPURegisterValues[r[1]]= int_to_binary_to_float(Memory[r[2]+RegisterValues[r[0]]]);
    myfloat var;
    var.i = Memory[r[2]+RegisterValues[r[0]]];
    FPURegisterValues[r[1]] = var.f;
    if(Mode == 0){
        print_register<<"lwc1 is executed with value: "<< FPURegisterValues[r[1]] <<"from address:  "<<r[2]+RegisterValues[r[0]]<<endl;
    }
}

void swc1(){
    update_biggest(r[2]+RegisterValues[r[0]]);
    myfloat var;
    var.f = FPURegisterValues[r[1]];
    Memory[RegisterValues[r[0]]+r[2]] = var.i ;
    if(Mode == 0){
        print_register<<"swc1 is executed with value: "<<FPURegisterValues[r[1]]<<" address:  "<< RegisterValues[r[0]]+r[2]<<endl;
    }

}

void lwc2(){
    update_biggest(RegisterValues[r[2]]+RegisterValues[r[0]]);
    myfloat var;
    var.i = Memory[RegisterValues[r[2]]+RegisterValues[r[0]]];
    FPURegisterValues[r[1]] = var.f;
    if(Mode == 0){
        print_register<<"lwc2 is executed with value: "<< FPURegisterValues[r[1]] <<"from address:  "<<RegisterValues[r[2]]+RegisterValues[r[0]]<<endl;
    }
}

void swc2(){
    update_biggest(RegisterValues[r[2]]+RegisterValues[r[0]]);
    myfloat var;
    var.f = FPURegisterValues[r[1]];
    Memory[RegisterValues[r[0]]+RegisterValues[r[2]]] = var.i ;
    if(Mode == 0){
        print_register<<"swc2 is executed with value: "<<FPURegisterValues[r[1]]<<" address:  "<< RegisterValues[r[0]]+RegisterValues[r[2]]<<endl;
    }

}

void outi(){
    if(Mode == 0){
        print_register<<"outi is executed with"<<RegisterValues[r[1]]<<endl;
    }
    //cout<<RegisterValues[r[1]];
    myfile<<RegisterValues[r[1]];
    //myfile2<<RegisterValues[r[1]];
}

int count_ = 0;
void outc(){
    if(Mode == 0){
        print_register<<"outc is executed with"<<RegisterValues[r[1]]<<endl;
    }
    if (count_ == 2){
      myfile<<RegisterValues[r[1]]<<endl;
    }
    else{
      myfile<<RegisterValues[r[1]]<<" ";
    }

    count_ = (count_ + 1)%3;

    myfile2<<(char)RegisterValues[r[1]];

}

void readi(){
    int32_t a;
    InputFile>>a;
    RegisterValues[r[1]]= a;
    if(Mode == 0){
        print_register<<"readi is executed with"<<RegisterValues[r[1]]<<endl;
    }
}

void readf(){
    float a;
    InputFile>>a;
    FPURegisterValues[r[1]]= a;
    if(Mode == 0){
        print_register<<"readf is executed with"<<FPURegisterValues[r[1]]<<endl;
    }
}
