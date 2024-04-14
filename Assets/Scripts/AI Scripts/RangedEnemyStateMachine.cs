using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

public class RangedEnemyStateMachine : SimpleStateMachine
{
    public MoveInRangeState moveInRange;
    public AttackState shoot;

    public bool LOS;
    //public float attackZone;
    public Transform target;
    public bool isAlive;

    private void Awake()
    {
        states.Add(moveInRange);
        states.Add(shoot);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        
    }

    void Start()
    {
        target = GameObject.FindGameObjectWithTag("Player").transform;

        ChangeState(nameof(MoveInRangeState));
    }
    void Update()
    {
        if(GetComponentInChildren<Health>().currentHealth > 0)
            isAlive = true;
        else
            isAlive = false;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }

}
