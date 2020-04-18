%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct _token{
    int clase;
    char valor[32];
    int line;
} token;
token TOKEN;
enum clase {ID=1, PALABRARESERVADA, ARITMETICO, RELACIONAL, ASIGNACION, LOGICO, PUNTUACION, ENT, FLOTANTE, };

void error(char *s);
%}

%option yylineno
%option noyywrap
%s COMENTARIO
%x COMENTARIO2

letra [a-zA-Z]
letra_ {letra}|_
digito [0-9]
id #{letra}({letra_}|{digito})*
palabrareservada "@if"|"@else"|"@while"
aritmetico [+-/*]
relacional "<"|">"|"<="|">="|"!="
asignacion "="
logico "||"|"&&"|"!"
puntuacion [(){};,]
entero ({digito})+
real {digito}*"."{digito}+|{digito}+"."{digito}*
exp [eE][+-]?{entero}
flotante ({real}{exp}?|{entero}{exp})[Ff]
%%
<INITIAL>{id}    { 
            TOKEN.clase = ID;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            return ID;
        		}
        
<INITIAL>{palabrareservada}  { 
                TOKEN.clase = PALABRARESERVADA;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return PALABRARESERVADA;
						}
  
<INITIAL>{aritmetico}  { 
                TOKEN.clase = ARITMETICO;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ARITMETICO;
						}
<INITIAL>{relacional}  { 
                TOKEN.clase = RELACIONAL;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return RELACIONAL;
						}
<INITIAL>{asignacion}  { 
                TOKEN.clase = ASIGNACION;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ASIGNACION;
						}
<INITIAL>{logico}  { 
                TOKEN.clase = LOGICO;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return LOGICO;
						}
<INITIAL>{puntuacion}  { 
                TOKEN.clase = PUNTUACION;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return PUNTUACION;
						}
  
<INITIAL>{entero}    { 
                TOKEN.clase = ENT;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ENT;
            }


<INITIAL>{flotante}  { 
                TOKEN.clase = FLOTANTE;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return FLOTANTE;
                

        }
<INITIAL>[ \t\n\r] {/* Ignora los espacios en blanco*/}
<INITIAL>"/*" {BEGIN(COMENTARIO);}
<INITIAL>.   {error(yytext);}

<COMENTARIO>[^*/]  {}
<COMENTARIO>[*/]   {}    
<COMENTARIO>"*/"   {BEGIN(INITIAL);}

<INITIAL>"//" {BEGIN(COMENTARIO2);}
<COMENTARIO2>"\n"   {BEGIN(INITIAL);}

%%
void error(char *s){
    printf("Error léxico: %s, en la línea %d\n",s,yylineno);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("Falta archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("No se puede abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    int tok = yylex();
    while(tok != 0){
        printf("%d\n",tok);
        tok = yylex();
    }    
    return 0;
}