using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpUpgrade : MonoBehaviour
{
    public UpgradeSystem upgradeSystem;
    public UpgradeHolder upgradeHolder;

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            upgradeSystem = other.gameObject.GetComponent<UpgradeSystem>();
            upgradeSystem.AddUpgrade(upgradeHolder.upgrade);
            Destroy(gameObject);
        }
    }
}
