using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Setter : MonoBehaviour
{
    public AttackState attackState;
    public void Set()
    {
        Debug.Log("Enemy attacking");
        attackState.isAttacking = true;
    }
    
}
