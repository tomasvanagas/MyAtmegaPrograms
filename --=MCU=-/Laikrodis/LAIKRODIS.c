char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3, Db_hz_praejo, SKAICIUS, OSC, a;
char valandos, minutes, sekundes;
char Hz_per_sekunde, mygtuko_uzlaikymas;

void zodis();
void oscilatorius();
void INPUTAI();
void valanda();
void minute();
void sekunde();
void VISUAL();
void filtravimas();

void main() {{
TRISA = 0b11100;
TRISB = 0;}
sekundes = 0;
minutes = 0;
valandos = 0;

Hz_per_sekunde = 100;

while(1){
Delay_ms(10);
oscilatorius();
INPUTAI();
sekunde();
minute();
valanda();

VISUAL();
filtravimas(); }}


void oscilatorius() {
OSC = OSC + 1;
if(OSC==8){
OSC = 0;}}


void INPUTAI(){
if((PORTA.F3==1)&&(mygtuko_uzlaikymas==0)){
MYGTUKAS_2 = 1;
mygtuko_uzlaikymas = 1;}
if((PORTA.F4==1)&&(mygtuko_uzlaikymas==0)){
MYGTUKAS_3 = 1;
mygtuko_uzlaikymas = 1;}
if((PORTA.F2==1)&&(mygtuko_uzlaikymas==0)){
MYGTUKAS_1 = 1;
mygtuko_uzlaikymas = 1;}
if((PORTA.F3==0)&&(PORTA.F4==0)&&(PORTA.F2==0)){
mygtuko_uzlaikymas = 0;}}


void valanda() {
if(MYGTUKAS_1==1) {
valandos = valandos + 1;}
if(minutes>=60) {
valandos = valandos + 1;
minutes = 0;}
if(valandos>=24) {
valandos = 0;}}


void minute() {
if(MYGTUKAS_3==1) {
minutes = minutes + 1;}
if(MYGTUKAS_2==1) {
minutes = minutes + 10;}
if(sekundes>=60) {
minutes = minutes + 1;
sekundes = 0;}}


void sekunde() {
if(OSC==7) {
Db_hz_praejo = Db_hz_praejo + 1;}
if(Db_hz_praejo==Hz_per_sekunde) {
sekundes = sekundes + 1;
Db_hz_praejo = 0;}}


void VISUAL() {

if(OSC == 0){
PORTB.F2 = 0;}
if(OSC == 2){
PORTB.F3 = 0;}
if(OSC == 4){
PORTB.F5 = 0;}
if(OSC == 6){
PORTB.F4 = 0;}


if(OSC/2*2!=OSC){
PORTB.F2 = 1;
PORTB.F3 = 1;
PORTB.F5 = 1;
PORTB.F4 = 1;
SKAICIUS = 15;}

PORTB.F6 = SKAICIUS.F0;
PORTA.F1 = SKAICIUS.F1;
PORTA.F0 = SKAICIUS.F2;
PORTB.F7 = SKAICIUS.F3;}


void filtravimas(){
MYGTUKAS_1 = 0;
MYGTUKAS_2 = 0;
MYGTUKAS_3 = 0;}