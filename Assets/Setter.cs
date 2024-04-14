using SuperPupSystems.Helper;
using UnityEngine;

public class Setter : MonoBehaviour
{
    public int dmg;
    public Health playerHealth;

    public AttackState attackState;


    public void Set()
    {
        if (playerHealth == null)
        {
            playerHealth = GameObject.Find("Player").GetComponent<Health>();
        }
        Debug.Log("Enemy attacking");
        playerHealth.Damage(dmg);
    }

}
