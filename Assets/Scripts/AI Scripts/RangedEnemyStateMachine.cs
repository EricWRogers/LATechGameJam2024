using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using static UnityEditor.VersionControl.Asset;
using static UnityEditor.PlayerSettings;

public class RangedEnemyStateMachine : SimpleStateMachine
{
    public MoveInRangeState moveInRange;
    public AttackState shoot;

    public bool LOS;
    public Transform target;


    private void Awake()
    {
        states.Add(moveInRange);
        states.Add(shoot);

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
