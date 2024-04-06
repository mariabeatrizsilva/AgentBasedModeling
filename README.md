# AgentBasedModeling
<h2> Introduction </h2>

How can we accurately model the spread of a disease in a population? Naturally, there are many factors and a lot of them are outside our control, but one thing we can do is consider the behavior and interactions of different individuals in a population. This technique is referred to as agent-based modeling. 

Our study focused on tracking the positions of individuals and monitoring the spread of disease as they move and interact. Our model starts with a certain number of infected people in the population where everyone else is susceptible to the disease. All individuals start in random positions, moving and interacting as the model runs. As they interact with each other, infected individuals may transmit the disease based on how close they are to others and a random probability. Moreover, infected people can die or recover depending on a uniform sampled probability.

<h2> Project Overview: Agent-based disease modeling </h2>
This project sought to develop a program that models a disease using an agent-based approach. Using this program, as is, you can edit the following parameters: 
<p align="center">
<img width="636" alt="params" src="https://github.com/mariabeatrizsilva/AgentBasedModeling/assets/67334485/5fe37722-fc45-4b84-858b-f4fa1598c3db">
<br> 

<h2> Visualization of the Spread of the Disease </h2>
Our program will generate the following three figures: 
<p align="center">
 <img width="846" alt="threegraphs" src="https://github.com/mariabeatrizsilva/AgentBasedModeling/assets/67334485/099f8305-3c08-4e3d-ab27-679dfec00724"> 
<br> 

Note that the leftmost and middle figure are just snapshots, and that these figures change as the program runs. Therefore, you can watch individuals interact and change state (susceptible, infected, recovered, dead). The rightmost figure is created once the individuals are finished moving. 

<h2> The Contents of this Repository</h2>

This repository contains

1. indiv.m : This is the indiviual class. Each instance of this class is an agent in the agent-based model. 
2. Project2_AgentBased_v3.m : This is the most robust version of the program. We have left previous iterations (v2 and v1) but recommend the use of v3 for any further work. 
3. Validation.m : This file was used to perform validation of our model, to ensure that our results were reliable regardless of the number of timesteps. 
4. PopulationSIRD.m : This is just a sample SIRD model with a plot that shows the trajectory of the disease throughout a population. This is not used in any of the aforementioned files and was part of our process in developing our final product, Project2_AgentBased_v3.m.
