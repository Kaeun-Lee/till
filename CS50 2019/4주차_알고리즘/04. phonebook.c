#include <cs50.h>
#include <stdio.h>
#include <string.h>

// typedef: 새로운 타입을 정의
// struct(구조체) : 여러 가지 자료형을 담는 그릇

// 구조체 정의(여기서, person이란 이름의 구조체를 "자료형"으로 정의)
typedef struct{           
     string name;
     string number;
} 
person;

int main(void){
    person people[4];

    people[0].name = "EMMA";
    people[0].number = "617-555-0100";

    people[1].name = "RODRIGO";
    people[1].number = "617-555-0101";

    people[2].name = "BRIAN";
    people[2].number = "617-555-0102";

    people[3].name = "DAVID";
    people[3].number = "617-555-0103";

    // EMMA 검색
    for (int i = 0; i < 4; i++){
        if (strcmp(people[i].name, "EMMA") == 0){
            printf("%s\n", people[i].number);
            return 0;
        }
    }
    printf("Not found\n");
    return 1;
}
