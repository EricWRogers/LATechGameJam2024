using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
    public bool isGamePaused = false;

    public PopUpChecker popUpChecker;

    public WinMenu winState;
    public LoseMenu loseState;

    public GameObject pauseMenuUI;

    public GameObject healthBar;
    public GameObject powerUpSection;
    public GameObject tMSection;
    public GameObject popUpSection;
    public GameObject reticle;

    void Start()
    {
        //pauseMenuUI.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape) && winState.didWin == false && loseState.didLose == false)
        {
            if(isGamePaused)
            {
                Resume();
            }else
            {
                Pause();
            }
        }   
    }

    public void Resume()
    {
        Debug.Log("Resume Button Was Hit");
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        pauseMenuUI.SetActive(false);
        healthBar.SetActive(true);
        powerUpSection.SetActive(true);
        tMSection.SetActive(true);
        reticle.SetActive(true);
        if(popUpChecker != null && popUpChecker.isOpen == true)
        {
            popUpChecker.OpenPopUp();
        }
        Time.timeScale = 1.0f;
        isGamePaused = false;
    }

    public void Pause()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        pauseMenuUI.SetActive(true);
        healthBar.SetActive(false);
        powerUpSection.SetActive(false);
        tMSection.SetActive(false);
        popUpSection.SetActive(false);
        reticle.SetActive(false);
        Time.timeScale = 0.0f;
        isGamePaused = true;
    }

    public void LoadMenu()
    {
        Debug.Log("Loading Main Menu");
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync("MainMenu");
    }

    public void QuitGame()
    {
        #if(UNITY_EDITOR)
        Debug.Log("Quiting Play Mode");
        EditorApplication.ExitPlaymode();
        #else
        Debug.Log("Quitting Build");
        Application.Quit();
        #endif
    }
}
