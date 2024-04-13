using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class MoveInRangeState : SimpleState
{
    public NavMeshAgent agent;
    private Vector3 target;

    public override void OnStart()
    {
        base.OnStart();
        //target = 
    }

    public override void UpdateState(float dt)
    {
       
    }
    public override void OnExit()
    {
        base.OnExit();


    }
}
