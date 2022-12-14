HARE_DEFINES:=\
	-D PLATFORM:str='"'"$(PLATFORM)"'"' \
	-D ARCH:str='"'"$(ARCH)"'"' \
	-D VERSION:str='"'"$$(./scripts/version)"'"' \
	-D HAREPATH:str='"'"$(HAREPATH)"'"' \
	-D AARCH64_AS:str='"'"$(AARCH64_AS)"'"' \
	-D AARCH64_AR:str='"'"$(AARCH64_AR)"'"' \
	-D AARCH64_CC:str='"'"$(AARCH64_CC)"'"' \
	-D AARCH64_LD:str='"'"$(AARCH64_LD)"'"' \
	-D RISCV64_AS:str='"'"$(RISCV64_AS)"'"' \
	-D RISCV64_AR:str='"'"$(RISCV64_AR)"'"' \
	-D RISCV64_CC:str='"'"$(RISCV64_CC)"'"' \
	-D RISCV64_LD:str='"'"$(RISCV64_LD)"'"' \
	-D X86_64_AS:str='"'"$(X86_64_AS)"'"' \
	-D X86_64_AR:str='"'"$(X86_64_AR)"'"' \
	-D X86_64_CC:str='"'"$(X86_64_CC)"'"' \
	-D X86_64_LD:str='"'"$(X86_64_LD)"'"'
