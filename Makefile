TARGET_NAME := tvm-test

BUILD_DIR := build
SRC_DIRS := src

STANDALONE_CRT_PATH=module/runtime/src/runtime/crt

SRCS := $(shell find $(SRC_DIRS) -name '*.c')
SRCS += $(shell find module/codegen/host/src -name '*.c')
SRCS += $(STANDALONE_CRT_PATH)/memory/stack_allocator.c
SRCS += $(STANDALONE_CRT_PATH)/common/crt_backend_api.c

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_DIRS += module/runtime/include
INC_DIRS += module/codegen/host/include
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS := -Wall -Wextra -Wpedantic $(INC_FLAGS) -MMD -MP
LDFLAGS := -lm

TARGET := $(BUILD_DIR)/$(TARGET_NAME)

CC := gcc

all: CFLAGS += -O3 -DNDEBUG
all: target

debug: CFLAGS += -g3 -D_FORTIFY_SOURCE=2
debug: target

san: debug
san: CFLAGS += -fsanitize=address,undefined
san: LDFLAGS += -fsanitize=address,undefined

target: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean compdb run

clean:
	@rm -rf $(addprefix $(BUILD_DIR)/,$(filter-out compile_commands.json,$(shell ls $(BUILD_DIR))))

compdb: clean
	@bear -- $(MAKE) san
	@mv compile_commands.json build

run: all
	./$(TARGET)
	./pyrun.sh

-include $(DEPS)
