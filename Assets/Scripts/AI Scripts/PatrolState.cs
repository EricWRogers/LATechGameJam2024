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

    float delay = 0;
    int points = 0;

    public override void OnStart()
    {

        base.OnStart();
        destination = ((BasicEnemyStateMachine)stateMachine).patrolPoints[0].position;
        agent.SetDestination(destination);
        Debug.Log("" + destination);



    }
    public override void UpdateState(float dt)
    {


        delay += Time.deltaTime;
        if (delay > 3f && points < ((BasicEnemyStateMachine)stateMachine).patrolPoints.Count)
        {

            if (agent.remainingDistance < .001)
            {
                Debug.Log("Arrived." + points);

                agent.SetDestination(((BasicEnemyStateMachine)stateMachine).patrolPoints[points].position);
                delay = 0;
                points++;
            }
        }
        if (points >= ((BasicEnemyStateMachine)stateMachine).patrolPoints.Count)
        {
            points = 0;
        }
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
    }
}