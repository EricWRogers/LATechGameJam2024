using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using static UnityEditor.VersionControl.Asset;
public class RangedEnemyStateMachine : SimpleStateMachine
{
    public MoveInRangeState moveIn;
    public AttackState shoot;
    public Transform target;


    private void Awake()
    {
        states.Add(shoot);
        states.Add(moveIn);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        ChangeState(nameof(moveIn));
    }

    void Start()
    {

    }

    void Update()
    {
        
        

    }

}
