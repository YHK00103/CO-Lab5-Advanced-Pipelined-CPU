# CO-Lab5-Advanced-Pipelined-CPU

## Goal
Modify your Lab 4 CPU design, and implement an advanced pipelined CPU
with (1)hazard detection and (2) data forwarding.

## Lab Requirement
1. Your CPU needs to support the following instructions:   
  I. Basic Instructions:  
    i. ADD  
    ii. ADDI  
    iii. SUB  
    iv. AND  
    v. OR  
    vi. SLT  
    vii. SLTI  
    viii. LW  
    ix. SW  
    x. MULT
II. Advanced Instructions
![image](https://github.com/YHK00103/CO-Lab5-Advanced-Pipelined-CPU/assets/117156581/67dd8485-3b98-4bfb-894b-d781f468889d)
(Modify Hazard Detection Unit to flush useless pipeline registers (IF/ID, ID/EX, 
EX/MEM) if a branch launch)  
III. You must implement(1) Hazard Detection Unit and (2) Forwarding
Unit.  
IV. Your CPU needs to forward data if instructions have data dependency.  
V. Your CPU needs to stall pipelined CPU if it detects a load-use

## Architecture Diagrams
![pipeline CPU 結構圖](https://github.com/YHK00103/CO-Lab5-Advanced-Pipelined-CPU/assets/117156581/2ebe7c41-10e6-4939-9c2d-0fdd33ae18bf)
