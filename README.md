Got you — here is the **updated README**, matching your new project description:

---

# **Rolling Average – VHDL Module**

## **Overview**

The **Rolling Average** module is a VHDL component that generates pseudo-random 8-bit numbers and computes their running average based on a user-selected sample size. This makes it useful for digital signal processing experiments, FPGA testing, and hardware-based statistical filtering.

---

## **Features**

* **Random number generation** (8-bit range)
* **Configurable averaging window**
  (number of samples determined by a control input)
* **Real-time rolling average output**
* **Clock-synchronous operation**
* **Resettable internal accumulators and counters**
* **Lightweight and FPGA-friendly design**

---

## **Inputs and Outputs**

### **Inputs**

| Signal    | Width | Description                         |
| --------- | ----- | ----------------------------------- |
| `CLK`     | 1     | System clock                        |
| `EN`      | 1     | Enables sampling and averaging      |
| `RST`     | 1     | Global synchronous reset            |
| `Control` | 3     | Selects how many samples to average |

### **Outputs**

| Signal       | Width | Description             |
| ------------ | ----- | ----------------------- |
| `OUT_RANDOM` | 8     | Generated random value  |
| `OUT_AVG`    | 8     | Current rolling average |

---

## **Operation Summary**

1. When `EN = '1'`, the module generates a new pseudo-random number each clock cycle.
2. The `Control` input selects how many samples (e.g., 2, 4, 8…) are used to compute the rolling average.
3. Internal counters and accumulators update on every clock edge.
4. The module outputs:

   * the **current random number**, and
   * the **rolling average** of the last *N* samples.
5. Reset clears all internal registers and restarts accumulation.

---

## **Use Cases**

* FPGA digital filtering demos
* Hardware-based data smoothing
* Random data test harnesses
* Teaching digital design concepts (accumulators, LFSRs, averaging)

---

## **File Structure**

```
RollingAverage.vhd     → Main VHDL module
```

---

## **Simulation**

To simulate:

1. Add `RollingAverage.vhd` to your project.
2. Drive:

   * `CLK`
   * `RST`
   * `EN`
   * `Control`
3. Monitor:

   * `OUT_RANDOM`
   * `OUT_AVG`

---

If you want, I can also generate:

✔ A matching LaTeX entry for your CV
✔ A testbench for the rolling average module
✔ A block diagram
✔ A cleaner or more formal README

Just say the word.
