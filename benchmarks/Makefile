CC = gcc
CFLAGS = -Wall -O3 -g

TARGET = baseline
SRC = baseline.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(TARGET)
