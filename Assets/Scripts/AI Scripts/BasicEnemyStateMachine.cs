using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

public class BasicEnemyStateMachine : SimpleStateMachine
{
    //States
    public MoveInRangeState moveIn;
    public AttackState attack;

    public bool LOS;
    public Transform target;
    public bool isAlive;


    private void Awake()
    {
        states.Add(moveIn);
        states.Add(attack);

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
        if (GetComponentInChildren<Health>().currentHealth > 0)
            isAlive = true;
        else
            isAlive = false;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }

}
