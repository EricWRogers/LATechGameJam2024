using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpgradePopUp : MonoBehaviour
{
    public PopUpChecker popUpChecker;

    public void OnTriggerEnter(Collider col)
    {
        if(col.gameObject.CompareTag("Player"))
        {
            Transform hudTransform = col.gameObject.transform.Find("HUD");

            if (hudTransform != null)
            {
                popUpChecker = hudTransform.GetComponent<PopUpChecker>();

                if (popUpChecker != null)
                {
                   popUpChecker.isOpen = true;
                }
                else
                {
                    Debug.LogWarning("PopUpChecker component not found on the HUD GameObject.");
                }
            }
        }
    }
}
