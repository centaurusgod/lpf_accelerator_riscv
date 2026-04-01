## Project Roadmap

### Completed
- ☑ Implement single cycle RISC-V processor

### To Do
- ☐ **Refactor single cycle processor code**
  - Remove unnecessary comments
  - Improve code formatting and readability
  - Optimize instruction memory assignments

- ☐ **Implement 5-stage pipeline RISC-V processor**
  - Design pipeline stages (IF, ID, EX, MEM, WB)
  - Handle data and control hazards
  - Implement forwarding logic
  - Develop comprehensive test suite
  
- ☐ **Fix overflow flag condition**
  - Revisit overflow detection logic
  - Handle edge cases
  - Add comprehensive test cases

- ☐ **Improve documentation**
  - Add module descriptions and diagrams
  - Document instruction encoding
  - Create implementation guide

- ☐ **Optimize circuit design**
  - Research alternative synthesis tools
  - Benchmark performance improvements


- ☐ **Add M-extension support (multiply extension)**
  - Add multiply and divide instruction decoders
  - Implement ALU operations for M-extension
  - Test arithmetic edge cases
  - Update instruction memory with M-extension tests


# Single Cycle RISC-V Processor
![Single Cycle RISC-V Processor](single_cycle_risc/single_cycle_processor.png)
