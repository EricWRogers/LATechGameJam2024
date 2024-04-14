using SuperPupSystems.Helper;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Setter : MonoBehaviour
{
    public int dmg;
    public Health playerHealth;


    public void Set()
    {
        Debug.Log("Enemy attacking");
        playerHealth.Damage(dmg);

    }
    
}
