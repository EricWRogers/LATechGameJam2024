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
    public ShootState shoot;
    public bool LOS;

    //Patrol var
    public List<Transform> patrolPoints;
    public List<Transform> targetPos;

    private void Awake()
    {
        states.Add(shoot);
        states.Add(moveIn);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        ChangeState(nameof(PatrolState));
    }

    void Start()
    {

    }

    void Update()
    {
        targetPos = gameObject.GetComponent<FOV>().visibleTargets;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }

}
