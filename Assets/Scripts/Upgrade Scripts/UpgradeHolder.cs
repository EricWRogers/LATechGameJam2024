using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpgradeHolder : MonoBehaviour
{
    public Upgrade upgrade1;
    public Upgrade upgrade2;
    public Upgrade upgrade3;

    public void PickUp(Upgrade chosenUpgrade)
    {
        chosenUpgrade.PickUp();
    }
}
