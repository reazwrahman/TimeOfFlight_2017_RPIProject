#define F_CPU		8000000 //8MHz

#include <asf.h>
#include <stdio.h>
#include <math.h>
#include <avr/io.h>
#include "i2c_master.h"		//Utilizes i2c_master library: https://github.com/g4lvanix/I2C-master-lib
#include <util/delay.h>

#define BAUD		500000
#define MYUBRR		F_CPU/8/BAUD - 1


int distance; // global variable

// ********************************************************************************
// Function Prototypes
// ********************************************************************************
void USART_Init(uint16_t ubrr);
unsigned char USART_Receive( void );
void USART_Transmit(unsigned char data );
int usart_putchar(char var, FILE *stream);
int usart_getchar(FILE *stream);

//Prototypes for I2C functionality
uint8_t i2c_read_8(char address, char reg);
uint16_t i2c_read_16(char address, char reg);
void i2c_write_8(char address, char reg, uint8_t command);
void i2c_write_16(char address, char reg, uint16_t command);

//Prototypes for Olivia functionality
void oliviaInitSimple( void ); 
void oliviaEnterStandby( void );
void oliviaSpecCfg( void );
void oliviaCPUOn( void );
int oliviaMeasurementOneSample( void );
void oliviaDevStatusGet( void );

void User_Dialog(void);


/********** Declaration of file for Uart ***********************************************************/
static FILE mystdout = FDEV_SETUP_STREAM(usart_putchar, usart_getchar, _FDEV_SETUP_RW);


//Misc. Globals
int oliviaAddress = 0x4C;

ISR(USART_RX_vect)
{
	unsigned char ReceivedByte = UDR0; // Fetch the received byte value into the variable "ByteReceived"
	if (ReceivedByte == 'A')
	{	
		UCSR0B &= ~(1<<RXCIE0); // Disabled RX interrupts
		User_Dialog();
	}
}


int main(void) {
//	int reading;   
	DDRB = 0x00; // Input for address
	PORTB = 0xFF; // Pullup
	DDRD = 0xFF; // Output for Usart and RS485 control
	PORTD |= (1<<PORTD0); // RXD
	PORTD |= (1<<PORTD1); // TXD
	PORTD &= ~(1<<PORTD2); // MAX3088 direction PC -> uC
	
	// setup our stdio stream
	stdin = stdout = &mystdout;
	//	unsigned char received;
	USART_Init(MYUBRR);
	oliviaAddress = oliviaAddress<<1;
	i2c_init();
	
	oliviaInitSimple();
	oliviaSpecCfg();
	oliviaCPUOn();
	oliviaDevStatusGet();
	_delay_ms(200);
	sei(); // Enable the Global Interrupt Enable flag so that interrupts can be processed

	while(1)
	{
		int reading = oliviaMeasurementOneSample();
		if ((reading >= 0) && (reading < 2500))
		{
			distance = reading;	
		}
		_delay_ms(100);
	}
}

void User_Dialog(){
	int val;
	scanf("%d", &val);
	PORTD |= (1<<PORTD2); // MAX3088 direction uC -> PC
	val = val & 0x00FF;
	if (val == (PINB ^= 0xFF)) 
	{
	//	printf ("%4d", distance);
	//	int dist = oliviaMeasurementOneSample();
		printf("%3d->%4d\n", (PINB ^= 0xFF), distance);
	}
	UCSR0B |= (1<<RXCIE0); // Enabled RX interrupts
	PORTD &= ~(1<<PORTD2); // MAX3088 direction PC -> uC
}

// ********************************************************************************
// usart Related
// ********************************************************************************
void USART_Init( uint16_t ubrr) {
	// Set baud rate
	UBRR0H = (uint8_t)(ubrr>>8);
	UBRR0L = (uint8_t)ubrr;
	
	// Asynchronous double speed
	UCSR0A = (1<<U2X0);
	
	// Enable receiver and transmitter
	UCSR0B = (1<<RXEN0)|(1<<TXEN0)|(1<<RXCIE0);
	// Set frame format: 8data, 1stop bit
	UCSR0C = (1<<USBS0)|(3<<UCSZ00);
}

void USART_Transmit( unsigned char data )
{
	/* Wait for empty transmit buffer */
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	/* Put data into buffer, sends the data */
	UDR0 = data;
}

unsigned char USART_Receive( void )
{
	/* Wait for data to be received */
	while ( !(UCSR0A & (1<<RXC0)) )
	;
	/* Get and return received data from buffer */
	return UDR0;
}

int usart_putchar(char var, FILE *stream)
{
	if (var == '\n')
	{
		usart_putchar('\r', stream);
	}
	USART_Transmit(var);
	return 0;
}

int usart_getchar(FILE *stream)
{
	unsigned char ch;
	while (!(UCSR0A & (1<<RXC0)));
	ch=UDR0;

	/* Echo the output back to the terminal */
	usart_putchar(ch,stream);

	return ch;
}
//I2C Wrapper Functions
uint8_t i2c_read_8(char address, char reg)
{
	uint8_t reading;
	i2c_start(address);
	i2c_write(reg);
	i2c_stop();
	_delay_us(500);
	i2c_start(address|0x01);
	reading = i2c_read_nack();
	i2c_stop();
	return reading;
}

uint16_t i2c_read_16(char address, char reg)
{
	uint16_t result;
	uint8_t reading1;
	uint8_t reading2;
	i2c_start(address);
	i2c_write(reg);
	i2c_stop();
	_delay_us(500);
	i2c_start(address|0x01);
	reading1 = i2c_read_ack();
	reading2 = i2c_read_nack();
	i2c_stop();
	result = reading2 << 8;
	result |= reading1;
	return result;
}

void i2c_write_8(char address, char reg, uint8_t command)
{
	i2c_start(address);
	i2c_write(reg);
	i2c_write(command);
	i2c_stop();
}

void i2c_write_16(char address, char reg, uint16_t command)
{
	uint8_t MSB = ((command & 0xFF00) >> 8);
	uint8_t LSB = (command & 0x00FF);
	i2c_start(address);
	i2c_write(reg);
	i2c_write(LSB);
	i2c_write(MSB);
	i2c_stop();
}

//Olivia Related
void oliviaInitSimple( void )
{
	int deviceReady = i2c_read_8(oliviaAddress, 0x00);
	_delay_ms(100);
	if(deviceReady & 0xF0) {
		i2c_write_8(oliviaAddress, 0x02, 0xF0);
	}
	i2c_write_8(oliviaAddress, 0x02, 0x0F);

	oliviaEnterStandby();

	i2c_write_8(oliviaAddress, 0x1C, 0x65);
	i2c_write_8(oliviaAddress, 0x00, 0x01);

	i2c_write_16(oliviaAddress, 0x14, 0x0600);
	i2c_write_16(oliviaAddress, 0x04, 0x0092);
	_delay_ms(2);
	i2c_write_8(oliviaAddress, 0x00, 0x04);
}

void oliviaEnterStandby( void )
{
	i2c_write_8(oliviaAddress, 0x1E, 0x02);
	i2c_write_8(oliviaAddress, 0x04, 0x90);
	
	_delay_ms(100);
}

void oliviaSpecCfg( void ) 
{
	i2c_write_16(oliviaAddress, 0x0C, 0xE100);  //addr_ADDA_RFSH
	i2c_write_16(oliviaAddress, 0x0E, 0x30FF);  //addr_ADDA_AUXCTRL
	i2c_write_16(oliviaAddress, 0x20, 0x07D0);  //addr_ADDA_HFCFG0
	i2c_write_16(oliviaAddress, 0x22, 0x5001);  //addr_ADDA_HFCFG1
	i2c_write_16(oliviaAddress, 0x24, 0xFFC0);  //addr_ADDA_HFCFG2
	i2c_write_16(oliviaAddress, 0x26, 0x4590);  //addr_ADDA_HFCFG3
}

void oliviaCPUOn( void ) 
{
	i2c_write_8(oliviaAddress, 0x15, 0x06);
	i2c_write_8(oliviaAddress, 0x04, 0x92);
	
	_delay_ms(100);
}

int oliviaMeasurementOneSample( void ) 
{
	int tries = 0;
	int maxTries = 50;
	uint8_t stat;
	bool successfulMeasurement = false;
	
	i2c_write_8(oliviaAddress, 0x04, 0x81);
	//_delay_ms(1);

	while((tries <= maxTries) && (!successfulMeasurement))
	{
		stat = i2c_read_8(oliviaAddress, 0x00);
		if((stat & 0x10) != 0x10) 
		{
			//_delay_ms(1);
			++tries;
		} else {
			successfulMeasurement = true;
			break;
		}
	}
	
	if(successfulMeasurement)
	{
		uint16_t output = i2c_read_16(oliviaAddress, 0x08);  
		int measurement = (output & 0x1FFC) >> 2;
		return measurement;
	} else {
		//printf("Read Error\r\n");
		return 0xFFFF;
	}

}

void oliviaDevStatusGet( void )
{
	int stat = i2c_read_8(oliviaAddress, 0x06);
	int piMcpuStatus = (stat & 0x1F);
	int piOscStatus = (stat & 0x20) >> 5;
	int piCpuWfiStatus = (stat & 0x40) >> 6;
	int piPowerStatus = (stat & 0x80) >> 7;
	//printf("\n");
	if(piMcpuStatus == 0x00)
	{
	//	printf("MCPU Standby\n");
	} else if(piMcpuStatus == 0x10) {
	//	printf("MCPU Off\n");
	} else if(piMcpuStatus == 0x18) {
	//	printf("MCPU On\n");
	} else {
	//	printf("MCPU ?\n");
	}
	
	if(piOscStatus)
	{
	//	printf("Oscillator On\n");
	} else {
	//	printf("Oscillator Off\n");
	}
	
	if(piCpuWfiStatus) 
	{
	//	printf("MCPU in WFI\n");
	} else {
	//	printf("MCPU in normal mode\n");
	}
	
	if(piPowerStatus)
	{
	//	printf("Vdd Okay\n");
	} else {
	//	printf("Vdd Bad\n");
	}
}