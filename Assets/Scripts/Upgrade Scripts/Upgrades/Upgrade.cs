using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades")]
public class Upgrade : ScriptableObject
{
        public float count;
        public bool active = false;
        public string upgradeName;
        public Sprite upgradeSprite;
        public Color newColor;
        public int dropChance;

        public virtual void PickUp()
        {

        }

        public virtual void Drop()
        {

        }

        public virtual void Active()
        {

        }

        public virtual void Passive()
        {
            //Debug.Log("Passive");
        }
}
