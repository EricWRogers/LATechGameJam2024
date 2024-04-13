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
    public Vector3 lastKnownPos;
    public bool isDone = false;

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
        if (Points < ((BasicEnemyStateMachine)stateMachine).targetPos.Count)
        {
            isDone = false;
            Debug.Log("Arrived." + Points);
            lastKnownPos = ((BasicEnemyStateMachine)stateMachine).targetPos[Points].position;
            agent.SetDestination(lastKnownPos);
            

        }
        if (agent.remainingDistance < 1)
        {
            isDone = true;
        }
            
            
       
        if (((BasicEnemyStateMachine)stateMachine).LOS == false && isDone)
        {
            stateMachine.ChangeState(nameof(PatrolState));
            
            

        }

    }
    public override void OnExit()
    {
        base.OnExit();
        agent.SetDestination(lastKnownPos);
        
        
    }
}
