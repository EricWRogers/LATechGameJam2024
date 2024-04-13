using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

[System.Serializable]
public class PatrolState : SimpleState
{
    public NavMeshAgent agent;
    private Vector3 destination;

    float f = 0;
    int i = 0;

    public override void OnStart()
    {

        base.OnStart();
        destination = ((BasicEnemyStateMachine)stateMachine).patrolPoints[0].position;
        agent.SetDestination(destination);
        Debug.Log("" + destination);


        
    }
    public override void UpdateState(float dt)
    {
        /* foreach (Transform point in ((BasicEnemyStateMachine)stateMachine).patrolPoints)
         {

             Debug.Log("Remaining dist: " + agent.remainingDistance);
             if (agent.remainingDistance < 1)
             {
                 //agent.ResetPath();
                 Debug.Log("" + point.position);
                 destination = point.position;
                 agent.SetDestination(destination);
             }
         }
        */

        f += Time.deltaTime;
       if(f> 3f && i < ((BasicEnemyStateMachine)stateMachine).patrolPoints.Count)
        {
            
            if (agent.remainingDistance < .001)
            {
                Debug.Log("Arrived."+i);
                
                agent.SetDestination(((BasicEnemyStateMachine)stateMachine).patrolPoints[i].position);
                f = 0;
                i++;
            }
        }
        if (i >= ((BasicEnemyStateMachine)stateMachine).patrolPoints.Count)
        {
            i = 0;
        }

    }

    void Jank()
    {
        
        if (agent.remainingDistance < .001)
        {
            Debug.Log("Arrived.");
        }
    }
}
