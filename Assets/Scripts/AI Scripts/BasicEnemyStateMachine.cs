using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using static UnityEditor.VersionControl.Asset;

public class BasicEnemyStateMachine : SimpleStateMachine
{
    //States
    public MoveInRangeState moveIn;
    public AttackState attack;

    public bool LOS;
    public Transform target;
    public float attackRange;
    public float attackZone;

    private void Awake()
    {
        states.Add(moveIn);
        states.Add(attack);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        ChangeState(nameof(MoveInRangeState));
    }

    void Start()
    {
    }
    void Update()
    {

        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }

}
