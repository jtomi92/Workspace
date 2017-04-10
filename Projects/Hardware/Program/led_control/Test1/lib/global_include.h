/*
 * global_include.h
 *
 * Created: 1/14/2017 8:50:37 PM
 *  Author: tjozsa
 */ 


#ifndef GLOBAL_INCLUDE_H_
#define GLOBAL_INCLUDE_H_

#ifndef F_CPU
#define F_CPU 16000000UL
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <string.h>
#include <stdlib.h>
#include <ws2812_config.h>
#include <light_ws2812.h>
#include <hw_utils.h>
#include <magic.h>
#include <colors.h>




#endif /* GLOBAL_INCLUDE_H_ */