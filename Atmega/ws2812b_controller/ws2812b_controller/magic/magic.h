/*
 * magic.h
 *
 * Created: 1/14/2017 9:29:50 PM
 *  Author: tjozsa
 */ 


#ifndef MAGIC_H_
#define MAGIC_H_

extern char MAX_LED_COUNT;

void setSpeed(const int sp);
void setMaxLedCount(const int size);
void setBrightness(const int brightness);
void Clear_Strip();
unsigned long Strip_Color(char g, char r, char b);
void Set_Color(unsigned long rred, unsigned int ggreen, char bblue, char position);
unsigned long Wheel(char WheelPos);
void RandomColor(int loops, int frame_speed);
void ChaseRandom(int loops);
void Fade_Strip(char rrednext, char ggreennext, char bbluenext, char rredlast, char ggreenlast, char bbluelast, int pos);
void Solid_Strip(char r1, char g1, char b1);
void InsertColor(char r1, char g1, char b1);
void FillLeft(char r1, char g1, char b1);
void FillRight(char r1, char g1, char b1);
void Fill_Any_PosR(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, char start, char end);
void Fill_Any_PosL(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, char start, char end);
void Chase_3Color_Left(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, int repeat);
void Chase_3Color_Right(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, int repeat);
void MovLeft_Chase_and_Clear(char position);
void MovRight_Chase_and_Clear(char position);
void Fill_Dot (char r1, char g1, char b1, char pos);
void Fill_Dot_PosR (char r1, char g1, char b1, char start, char end);
void Fill_Dot_PosL(char r1, char g1, char b1, char start, char end);
void rainbowCycleLeft(unsigned char cycles, int frame_speed);
void rainbowCycleRight(unsigned char cycles, int frame_speed);
void CometLeft(unsigned char rred, unsigned char ggreen, unsigned char bblue);
void CometRight(unsigned char rred, unsigned char ggreen, unsigned char bblue);
void doTheBoogie();




#endif /* MAGIC_H_ */