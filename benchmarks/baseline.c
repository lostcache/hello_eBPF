#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include <stdint.h>
#include <assert.h>

#define CHUNK_SIZE_BYTES (64 * 1024)
#define PATTERN "Alpha"
#define PATTERN_LEN_BYTES 5

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    const char *filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("Error opening file");
        return 1;
    }

    // Static allocation
    static char buffer[CHUNK_SIZE_BYTES];
    size_t overlap_len_bytes = PATTERN_LEN_BYTES - 1;
    size_t offset_bytes = 0; 
    ssize_t bytes_read;
    uint64_t total_count = 0;

    struct timespec start, end;
    int clock_res = clock_gettime(CLOCK_MONOTONIC, &start);
    assert(clock_res == 0);

    while ((bytes_read = read(fd, buffer + offset_bytes, CHUNK_SIZE_BYTES - offset_bytes)) > 0) {
        size_t total_len_bytes = (size_t)bytes_read + offset_bytes;
        
        // Assert invariants
        assert(total_len_bytes <= CHUNK_SIZE_BYTES);

        const char *ptr = buffer;
        const char *limit = buffer + total_len_bytes - PATTERN_LEN_BYTES + 1;
        
        if (total_len_bytes < PATTERN_LEN_BYTES) {
            offset_bytes = total_len_bytes;
            continue;
        }

        while (ptr < limit) {
            if (memcmp(ptr, PATTERN, PATTERN_LEN_BYTES) == 0) {
                total_count++;
                ptr += PATTERN_LEN_BYTES;
            } else {
                ptr++;
            }
        }

        size_t bytes_to_keep = (total_len_bytes < overlap_len_bytes) ? total_len_bytes : overlap_len_bytes;
        memmove(buffer, buffer + total_len_bytes - bytes_to_keep, bytes_to_keep);
        offset_bytes = bytes_to_keep;
    }

    // Assert that read() either hit EOF (0) or failed (-1). 
    // If failed, we should probably handle it, but for a benchmark, exit is acceptable if strict.
    // TigerStyle encourages handling all errors.
    if (bytes_read < 0) {
        perror("Read failed");
        close(fd);
        return 1;
    }

    clock_res = clock_gettime(CLOCK_MONOTONIC, &end);
    assert(clock_res == 0);
    
    double time_taken_s = (double)(end.tv_sec - start.tv_sec) + \
                          (double)(end.tv_nsec - start.tv_nsec) / 1e9;

    printf("Count: %lu\n", total_count);
    printf("Time: %.6f seconds\n", time_taken_s);
    
    close(fd);
    return 0;
}
