using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PopUpChecker : MonoBehaviour
{
    public GameObject popUp;
    public UpgradeSystem playerUpgradeSystem;
    
    public bool isOpen = false;
    
    public TMP_Text upgradeNameText;
    public TMP_Text upgradeDescriptionText;
    public Image upgradeIcon;

    void Start()
    {
        popUp.SetActive(false);
    }

    void Update()
    {
        if(isOpen == true)
        {
            Debug.Log("Open the Pop Up");
            OpenPopUp();
        }
    }
    
    public void OpenPopUp()
    {
        popUp.SetActive(true);
        Time.timeScale = 0.0f;
        if(playerUpgradeSystem.upgrades.Count == 1)
        {
            upgradeNameText.text = playerUpgradeSystem.upgrades[0].upgradeName;
            upgradeDescriptionText.text = playerUpgradeSystem.upgrades[0].upgradeDescription;
            upgradeIcon.sprite = playerUpgradeSystem.upgrades[0].upgradeSprite;
        }
        else if(playerUpgradeSystem.upgrades.Count > 1)
        {
            int lastIndex = playerUpgradeSystem.upgrades.Count-1;
            upgradeNameText.text = playerUpgradeSystem.upgrades[lastIndex].upgradeName;
            upgradeDescriptionText.text = playerUpgradeSystem.upgrades[lastIndex].upgradeDescription;
            upgradeIcon.sprite = playerUpgradeSystem.upgrades[lastIndex].upgradeSprite;
        }
    }

    public void ClosePopUp()
    {
        popUp.SetActive(false);
        isOpen = false;
        Time.timeScale = 1.0f;
    }
}
