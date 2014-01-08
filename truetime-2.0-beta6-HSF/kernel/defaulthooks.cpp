/*
 * Copyright (c) 2009 Lund University
 *
 * Written by Anton Cervin, Dan Henriksson and Martin Ohlin,
 * Department of Automatic Control LTH, Lund University, Sweden.
 *   
 * This file is part of Truetime 2.0 beta.
 *
 * Truetime 2.0 beta is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Truetime 2.0 beta is distributed in the hope that it will be useful, but
 * without any warranty; without even the implied warranty of
 * merchantability or fitness for a particular purpose. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Truetime 2.0 beta. If not, see <http://www.gnu.org/licenses/>
 */

#ifndef DEFAULT_HOOKS
#define DEFAULT_HOOKS

/**
 * Default hooks used to implement overrun handling, 
 * context switch simulation and logging.
 */

#include "logstart.cpp"
#include "logstop.cpp"
#include "lognow.cpp"

/* forward declaration */



void default_runkernel(UserTask *task, double duration) {

  task->budget -= duration;

}

void default_arrival(UserTask *task) {

  // Store arrival time in relevant logs
  logstart(task->logs[RESPONSETIMELOG]);
  logstart(task->logs[RELEASELATENCYLOG]);
  logstart(task->logs[STARTLATENCYLOG]);
}


void default_release(UserTask *task) {

  // Calculate absolute deadline and assign execution budget 
  task->arrival = rtsys->time;
  task->absDeadline = task->arrival + task->deadline;
  task->budget = task->wcExecTime;

  // Simulate context switch  
  if (rtsys->contextSwitchTime > TT_TIME_RESOLUTION) {
    rtsys->contextSimTime = rtsys->contextSwitchTime;
    invoke_task(rtsys->kernelHandler, "");
  }
  // Set the deadline overrun timer (if there is one)
  if (task->DLtimer != NULL) {
	  if((int)task->absDeadline <= (int)rtsys->time)
	  {
		  //task->absDeadline = task->absDeadline + task->deadline ;
		  //debugPrintf("Fixed!");
		  //debugPrintf("******timeQ insertion problem: for task '%s' for time %5.8f at time %5.8f arrival = %5.8f, deadline = %5.8f release = %5.8f \n",task->name, task->absDeadline, rtsys->time, task->arrival, task->deadline, task->release);
	  }
	  
    task->DLtimer->time = task->absDeadline;
    task->DLtimer->moveToList(rtsys->timeQ);
  }

  // Store release latency in log
  logstop(task->logs[RELEASELATENCYLOG]);
}

void default_start(UserTask *task) {
	//Nima
	//if(task->isDLMissed)
		//debugPrintf("Deadline miss flag reseted %s\n", task->name);
	//task->isDLMissed = false; //Reset DL Miss flag
	//Manage from task_code.m 
	
  //debugPrintf("Start-hook for task '%s' at time %5.8f\n",task->name,rtsys->time);
  // Set the execution-time overrun timer (if there is one)
  if (task->WCETtimer != NULL && task->budget > TT_TIME_RESOLUTION) {
    task->WCETtimer->time = rtsys->time + task->budget;
    task->WCETtimer->moveToList(rtsys->timeQ);
  }

  // store start latency in log
  logstop(task->logs[STARTLATENCYLOG]);  

  // execution time log entry
  Log* log = task->logs[EXECTIMELOG-1];
  if (log) {
    if (log->entries < log->size) {
      log->vals[log->entries] = 0.0;
      log->temp = simtime2time(rtsys->time);
    }
  }

}


void default_suspend(UserTask* task) {

  //debugPrintf("Suspend-hook for task '%s' at time %5.8f\n",task->name,rtsys->time);

  // Remove exectime-time overrun timer from timeQ (if it exists)
  if (task->WCETtimer) {
    task->WCETtimer->remove();
  }

  if (rtsys->contextSwitchTime > TT_TIME_RESOLUTION) {
    rtsys->contextSimTime = rtsys->contextSwitchTime;
    invoke_task(rtsys->kernelHandler, "");
  } 

  // update execution time log entry
  Log *log = task->logs[EXECTIMELOG-1];
  if (log) {
    if (log->entries < log->size) {
      log->vals[log->entries] += (simtime2time(rtsys->time) - log->temp);
      log->temp = simtime2time(rtsys->time);
    }
  }
}


void default_resume(UserTask* task) {

  //debugPrintf("Resume-hook for task '%s' at time %5.8f\n",task->name,rtsys->time);

  // Set the execution-time overrun timer (if there is one)
  if (task->WCETtimer != NULL && task->budget > TT_TIME_RESOLUTION) {
    task->WCETtimer->time = rtsys->time + task->budget;
    task->WCETtimer->moveToList(rtsys->timeQ);
  }
}


void default_finish(UserTask* task) {

  //debugPrintf("Finish-hook for task '%s' at time %5.8f\n",task->name,rtsys->time);

  // Remove deadline and exectime overrun timers from timeQ (if they exist)
  if (task->DLtimer) {
    task->DLtimer->remove();
	//debugPrintf("finish:timer %s is removed at %5.8f\n", task->DLtimer->name, rtsys->time);
  }
  if (task->WCETtimer) {
    task->WCETtimer->remove();
  }
  // Simulate context switch  
  if (rtsys->contextSwitchTime > TT_TIME_RESOLUTION) {
    rtsys->contextSimTime = rtsys->contextSwitchTime; 
    invoke_task(rtsys->kernelHandler,"");
  } 
  
  // store response time in log
  logstop(task->logs[RESPONSETIMELOG]);  

  // store execution time in log
  Log* log = task->logs[EXECTIMELOG];
  if (log) {
    double exectime = log->vals[log->entries] + (simtime2time(rtsys->time) + 
				rtsys->contextSwitchTime - log->temp);
    logwrite(log, exectime);
  }
}

#endif
