using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpgradeHolder : MonoBehaviour
{
    public Upgrade upgrade;

  

    public void PickUp()
    {
        upgrade.PickUp();
    }
}
