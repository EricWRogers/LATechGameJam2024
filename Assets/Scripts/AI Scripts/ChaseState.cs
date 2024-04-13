using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using Unity.VisualScripting;

[System.Serializable]
public class ChaseState : SimpleState
{
    public NavMeshAgent agent;
    private Vector3 destination;

    float delay = 0;
    int Points = 0;

    public override void OnStart()
    {

        base.OnStart();
        destination = ((BasicEnemyStateMachine)stateMachine).targetPos[0].position;
        agent.SetDestination(destination);
    }
    
    public override void UpdateState(float dt)
    {
        delay += Time.deltaTime;
        if (delay > 3f && Points < ((BasicEnemyStateMachine)stateMachine).targetPos.Count)
        {

            if (agent.remainingDistance < .001)
            {
                Debug.Log("Arrived." + Points);

                agent.SetDestination(((BasicEnemyStateMachine)stateMachine).targetPos[Points].position);
                delay = 0;
                Points++;
            }
        }
        if (Points >= ((BasicEnemyStateMachine)stateMachine).targetPos.Count)
        {
            Points = 0;
        }
        if (((BasicEnemyStateMachine)stateMachine).LOS == false && agent.remainingDistance < 1)
        {
            stateMachine.ChangeState(nameof(PatrolState));

        }

    }
    public override void OnExit()
    {
        base.OnExit();
        
    }
}
