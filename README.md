# RISC-V RV32I Single-Cycle Processor

A 32-bit RISC-V RV32I single-cycle processor implemented using
SystemVerilog.

---

## 🧠 Processor Architecture

The following diagram shows the complete architecture of the
RV32I single-cycle processor.

![RISC-V Processor Architecture](Diagrams/Screenshot From 2026-08-19 20-48-52.png)

---

## 🔄 Single-Cycle Datapath

The datapath connects the Program Counter, Instruction Memory,
Register File, ALU, Data Memory, Control Unit, and Write-Back logic.

![RISC-V Datapath](images/riscv_datapath.png)

---

## 🧩 RTL Schematic

The synthesized RTL schematic shows the hardware-level
interconnection of the processor modules.

![RTL Schematic](images/rtl_schematic.png)

---

## 🧪 Simulation

The processor was verified using RTL simulation. The waveform
below demonstrates instruction execution and the behavior of
important processor signals.

![Simulation Waveform](images/simulation_waveform.png)

---

## 📖 RV32I Instruction Set

The processor implements the required RV32I instructions,
including arithmetic, logical, memory, branch, and jump
operations.

| Type | Instructions |
|------|--------------|
| R-Type | ADD, SUB, AND, OR, XOR, SLT |
| I-Type | ADDI, ANDI, ORI, XORI, SLTI |
| Load | LW |
| Store | SW |
| Branch | BEQ, BNE, BLT, BGE |
| Jump | JAL, JALR |

---

## ⚙️ Processor Components

| Component | Description |
|-----------|-------------|
| Program Counter | Holds the address of the current instruction |
| Instruction Memory | Stores program instructions |
| Control Unit | Generates control signals |
| Register File | Contains 32 general-purpose 32-bit registers |
| Immediate Generator | Generates immediate operands |
| ALU | Performs arithmetic and logical operations |
| Data Memory | Handles load/store operations |
| Branch Unit | Determines branch decisions |
| Write-Back Unit | Selects data written to registers |

---

## 🔄 Instruction Execution

Each instruction is completed within a single clock cycle:

```text
Instruction Fetch
        ↓
Instruction Decode
        ↓
     Execute
        ↓
  Memory Access
        ↓
    Write Back
