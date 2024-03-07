.DEFAULT_GOAL := test

WORK_DIR       = $(shell pwd)
DST_DIR        = $(WORK_DIR)/build/objs
$(shell mkdir -p $(DST_DIR))

TARGET         = $(abspath build/target)

APPS           = $(shell find src/ -name *.c)
APPS_OBJ       = $(addprefix $(DST_DIR)/, $(addsuffix .o, $(basename $(APPS))))

LDFLAGS       += -T $(WORK_DIR)/sections.ld 
LDFLAGS       += --gc-sections -e _start
LDFLAGS       += -melf32lriscv

COMMON_FLAGS  += -fno-pic -march=rv32im -mabi=ilp32 -fno-stack-protector
CXXFLAGS      += $(COMMON_FLAGS) -static
ASFLAGS       += $(COMMON_FLAGS) -O0

CROSS_COMPILE += /opt/riscv/bin/riscv64-unknown-linux-gnu-

$(DST_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CROSS_COMPILE)gcc $(CXXFLAGS) -c -o $@ $(realpath $<)

$(DST_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	@$(CROSS_COMPILE)gcc $(ASFLAGS)  -c -o $@ $(realpath $<)

generate: $(APPS_OBJ)
	@$(CROSS_COMPILE)ld $(LDFLAGS) -o $(TARGET).elf --start-group $(APPS_OBJ) --end-group
	@$(CROSS_COMPILE)objdump -d $(TARGET).elf > $(TARGET).txt

clean:
	find $(WORK_DIR)/build/* | grep -v Makefile | xargs rm -rf

