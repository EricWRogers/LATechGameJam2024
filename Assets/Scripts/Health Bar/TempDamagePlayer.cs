using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;

public class TempDamagePlayer : MonoBehaviour
{
    public Health health;

    private void OnTriggerEnter(Collider col)
    {
        if(col.CompareTag("Player"))
        {
            health.Damage(5);
        }
    }
}
