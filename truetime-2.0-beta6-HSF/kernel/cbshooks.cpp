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

#ifndef CBS_HOOKS
#define CBS_HOOKS

/**
 * CBS hooks to implement soft and hard constant-bandwidth servers.
 * See also the additional handler code in createcbs.cpp
 */


void CBS_runkernel(UserTask *task, double duration) {
  
  rtsys->default_runkernel(task, duration);
  
  task->cbs->cs -= duration;
  task->cbs->assignedCs += duration;
  if(task->isDLMissed){
	  task->cbs->error += duration;
	  debugPrintf("running after deadline task: %s duration: %f error %f flag %d\n", task->name, duration, task->cbs->error, task->isDLMissed);
	  }
}


void CBS_arrival(UserTask *task) {
//debugPrintf("CBS_arrival %s at %5.8f \n", task->name, rtsys->time);

  rtsys->default_arrival(task);

  CBS* cbs = task->cbs;

  // Is the server idle?
  if (cbs->nbrJobs == 0) {
	  //debugPrintf("CBS_arrival: server is idle %s at %5.8f \n", cbs->name, rtsys->time);
    // "Reset" the server if c_s >= (d_s - r)*U_s
    if (cbs->cs*cbs->Ts >= (cbs->ds - rtsys->time)*cbs->Qs) {
		//debugPrintf("CBS_arrival: condition is correct %s at %5.8f \n", cbs->name, rtsys->time);
      cbs->ds = rtsys->time + cbs->Ts;
	  cbs->unusedCs += cbs->cs;
	  //debugPrintf("CBS_arrival:Budget refilled %s at %5.8f \n", cbs->name, rtsys->time);
      cbs->cs = cbs->Qs;
      cbs->nbrPeriods++;
    }
  }
  // Increase the current number of jobs in the cbs
  cbs->nbrJobs++;

  //mexPrintf("CBS_arrival %s @%.4f: nbrJobs = %d, deadline = %.4f, budget = %.4f\n", task->name, rtsys->time, cbs->nbrJobs, cbs->ds, cbs->cs);


}


void CBS_start(UserTask *task) {
  
  CBS* cbs = task->cbs;
	//debugPrintf("CBS_Start %s at %5.8f \n", task->name, rtsys->time);

  if (cbs->type == 1 && cbs->state == CBS_OVERLOAD) {

    // The CBS is overloaded, so the task cannot start. Reset everything
    // and put the task to sleep
    task->segment = 0;                    // Undo the task start
    task->release = cbs->overloadEndTime; // Set wake-up at old CBS deadline
    task->moveToList(rtsys->timeQ);       // Put it to sleep

  } else {

    rtsys->default_start(task);
    
    // Set the CBS budget timer
    cbs->cbsTimer->time = rtsys->time + cbs->cs;
    cbs->cbsTimer->moveToList(rtsys->timeQ);
    
    //mexPrintf("CBS_start %s @%.4f, timer set to %.4f\n", task->name, rtsys->time, cbs->cbsTimer->time);
    
  }

}


void CBS_suspend(UserTask* task) {

  rtsys->default_suspend(task);

  CBS* cbs = task->cbs;
  //debugPrintf("CBS_suspend %s at %5.8f \n", task->name, rtsys->time);
  // Remove the cbs timer from timeQ
  cbs->cbsTimer->remove();

  //mexPrintf("CBS_suspend at %5.8f\n", rtsys->time);
}


void CBS_resume(UserTask* task) {
		  

  CBS* cbs = task->cbs;
  //debugPrintf("CBS_Resume %s at %5.8f \n", task->name, rtsys->time);
 
  if (cbs->type == 1 && cbs->state == CBS_OVERLOAD) {

    // The CBS is overloaded, so the task cannot start.
    task->release = cbs->overloadEndTime;  // Set wake-up at old CBS deadline
    task->moveToList(rtsys->timeQ);        // Put it to sleep

  } else {

    rtsys->default_resume(task);

    // Check the validity of the CBS deadline and update it if necessary
    if (rtsys->time >= cbs->ds) {
      cbs->ds = rtsys->time + cbs->Ts;
	  cbs->unusedCs += cbs->cs;
	  //debugPrintf("CBS_resume:Budget refilled %s at %5.8f \n", cbs->name, rtsys->time);
      cbs->cs = cbs->Qs;
      cbs->nbrPeriods++;
     }

    // Set the CBS budget timer
    cbs->cbsTimer->time = rtsys->time + cbs->cs;
    cbs->cbsTimer->moveToList(rtsys->timeQ);

    //mexPrintf("CBS_resume %s, timer set to %5.8f\n", task->name, cbs->cbsTimer->time);

  }
}


void CBS_finish(UserTask *task) {

  rtsys->default_finish(task);
  
  CBS* cbs = task->cbs;
  
  // Remove the cbs timer from timeQ
  cbs->cbsTimer->remove();

  // Decrease current number of jobs in the cbs
  cbs->nbrJobs--;
	
  //mexPrintf("CBS_finish %s @%.4f: nbrJobs = %d\n", task->name, rtsys->time, cbs->nbrJobs);
}

#endif
