using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class MoveInRangeState : SimpleState
{
    public NavMeshAgent agent;
    public Transform target;

    public override void OnStart()
    {
        base.OnStart();
        agent.SetDestination(target.position);
    }

    public override void UpdateState(float dt)
    {
       
    }
    public override void OnExit()
    {
        base.OnExit();


    }
}
