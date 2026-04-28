# 24-Hour Digital Clock (Verilog RTL Design)

## Overview

This project implements a 24-hour digital clock using Verilog HDL. The design follows a modular RTL approach based on cascaded counter architecture to represent seconds, minutes, and hours in HH:MM:SS format. Proper carry propagation between counters ensures correct time progression and rollover behavior.

---

## Design Approach

The system is designed using hierarchical counters with separation between unit and tens digits. Each time component (seconds, minutes, hours) is implemented as an independent module and connected using enable and carry signals.

The design is synchronous, with all state transitions occurring on the positive edge of the clock.

---

## Counter Implementation

### Seconds Counter

The seconds counter is implemented using two stages:

* Unit counter: counts from 0 to 9
* Tens counter: counts from 0 to 5

This forms a modulo-60 counter (00 to 59). When the count reaches 59, it resets to 00 and generates a carry signal to increment the minutes counter.

---

### Minutes Counter

The minutes counter follows the same structure:

* Unit counter: counts from 0 to 9
* Tens counter: counts from 0 to 5

It is enabled by the carry output of the seconds counter. Upon reaching 59, it resets to 00 and generates a carry signal for the hours counter.

---

### Hours Counter

The hours counter operates in 24-hour format (00 to 23).
The logic ensures:

* Normal increment from 00 to 22
* Transition from 23 to 00 on the next valid increment

This counter is driven by the carry signal from the minutes counter.

---

## Carry Propagation

The design uses hierarchical carry propagation:

* Seconds rollover generates carry to minutes
* Minutes rollover generates carry to hours

This ensures synchronized and glitch-free operation across all counters.

---

## 7-Segment Display Interface

A combinational decoder is used to convert 4-bit BCD inputs into 7-segment display outputs.

Each digit of the clock (HH:MM:SS) is connected to a dedicated decoder, allowing the values to be displayed in human-readable format.

### BCD to 7-Segment Mapping

| Digit | Segment Output (Hex) |
| ----- | -------------------- |
| 0     | 7E                   |
| 1     | 30                   |
| 2     | 6D                   |
| 3     | 79                   |
| 4     | 33                   |
| 5     | 5B                   |
| 6     | 5F                   |
| 7     | 70                   |
| 8     | 7F                   |
| 9     | 7B                   |

The simulation waveform confirms that the segment outputs correctly match the expected encoding for all digits.

---

## Verification

A structured testbench was used to validate the design. The following conditions were verified:

* Correct reset initialization
* Continuous counting behavior
* Rollover conditions:

  * 59 to 00 transition for seconds and minutes
  * 23 to 00 transition for hours
* Proper carry propagation between counters

### Test Results

```
PASS: 00:09:59 → 00:10:00  
PASS: 00:59:59 → 01:00:00  
PASS: 23:59:59 → 00:00:00  
ALL TESTS PASSED
```

Simulation was performed using Xilinx Vivado XSim.
## Simulation Results

### Rollover Verification: 59 to 00

The waveform below shows the seconds counter rolling over from 59 to 00. At the same transition, the minutes counter increments from 0 to 1, confirming correct carry propagation between counters.

![Rollover](docs/rollover_59_to_00.png)
---

## Project Structure

```text
rtl/   - Verilog design modules  
tb/    - Testbench files  
docs/  - Simulation waveforms (optional)
```

---

## Tools Used

* Verilog HDL
* Xilinx Vivado
* XSim Simulator

---

## Future Work

* Integration with physical 7-segment display hardware
* Implementation of 12-hour format with AM/PM indication
* Addition of alarm functionality
* Clock divider for real-time hardware operation
* Enhanced self-checking testbench

---

## Conclusion

This project demonstrates the implementation of a synchronous digital system using modular RTL design principles. It highlights counter-based design, carry propagation, and functional verification through simulation. The inclusion of a 7-segment decoder further extends the design towards practical display applications.

---

## Author

Sarisha Vij
Electronics and Communication Engineering
Aspiring RTL / VLSI Design Engineer
