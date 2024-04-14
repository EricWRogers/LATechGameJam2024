using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

/*[System.Serializable]
public struct DialogueBox
{
    public string Name;
    public Sprite Icon;
    public string Description;
}*/

public class UpgradeDatabase : MonoBehaviour
{
    public List<Upgrade> upgrades;
    public List<Upgrade> updatedUpgrades;

    public bool isHighligthed = false;
    public bool nameOneDes = false;
    public bool nameTwoDes = false;
    public bool nameThreeDes = false;

    public GameObject popUpUI;
    public GameObject USB;

    public TMP_Text upgradeNameOneText;
    public TMP_Text upgradeNameTwoText;
    public TMP_Text upgradeNameThreeText;

    public Sprite iconOne;
    public Sprite iconTwo;
    public Sprite iconThree;

    public TMP_Text upgradeDescriptionText;

    // Start is called before the first frame update
    void Start()
    {
        ShuffleList(upgrades);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void ShuffleList<T>(List<T> list)
    {
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = Random.Range(0, n + 1);
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
    }

    public void OpenPopUp()
    {
        
        ShuffleList(upgrades);

        List<Upgrade> firstThreeUpgrades = new List<Upgrade>();
        for (int i = 0; i < Mathf.Min(3, upgrades.Count); i++)
        {
            firstThreeUpgrades.Add(upgrades[i]);
            upgradeNameOneText.text = firstThreeUpgrades[0].name;
            upgradeNameTwoText.text = firstThreeUpgrades[1].name;
            upgradeNameThreeText.text = firstThreeUpgrades[2].name; 
        }

        upgradeNameOneText.text = firstThreeUpgrades[0].upgradeName;
        iconOne = firstThreeUpgrades[0].upgradeSprite;
        upgradeNameTwoText.text = firstThreeUpgrades[1].upgradeName;
        iconTwo = firstThreeUpgrades[1].upgradeSprite;
        upgradeNameThreeText.text = firstThreeUpgrades[2].upgradeName;
        iconThree = firstThreeUpgrades[2].upgradeSprite; 
        
        if(nameOneDes == true)
        {
            upgradeDescriptionText.text = firstThreeUpgrades[0].upgradeDescription;
        }
        if(nameTwoDes == true)
        {
            upgradeDescriptionText.text = firstThreeUpgrades[1].upgradeDescription;
        }
        if(nameThreeDes == true)
        {
            upgradeDescriptionText.text = firstThreeUpgrades[2].upgradeDescription;
        }

        updatedUpgrades = firstThreeUpgrades;

    }

    public void HighligthIconOne()
    {
        nameOneDes = true;
        nameTwoDes = false;
        nameThreeDes = false;
    }

    public void HighligthIconTwo()
    {
        nameTwoDes = true;
        nameOneDes = false;
        nameThreeDes = false;
    }

    public void HighligthIconThree()
    {
        nameThreeDes = true;
        nameOneDes = false;
        nameTwoDes = false;
    }

    public void RemoveUpgrade()
    {
        if(nameOneDes == true)
        {
            updatedUpgrades.RemoveAt(0);
        }
        if(nameTwoDes == true)
        {
            updatedUpgrades.RemoveAt(1);
        }
        if(nameThreeDes == true)
        {
            updatedUpgrades.RemoveAt(3);
        }
        
    }

    public void RandomSelectRemainder()
    {
        if (updatedUpgrades.Count == 2)
        {
            int randomIndex = Random.Range(0, 2);

            updatedUpgrades.RemoveAt(randomIndex);

            UpdatePopUpUI();
        }
    }

    private void UpdatePopUpUI()
    {
    // Update the UI based on the remaining upgrades
        if (updatedUpgrades.Count >= 1)
        {
            upgradeNameOneText.text = updatedUpgrades[0].upgradeName;
            upgradeDescriptionText.text = updatedUpgrades[0].upgradeDescription;
        }
    }

    

}
