<%@ Page Title="Collaborative Editor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CDE._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        background: #ffffff;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        color: #333;
    }

    .editor-container {
        display: flex;
        flex-direction: column;
        height: calc(100vh - 200px);
        background: #ffffff;
    }

    .top-bar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px 24px;
        border-bottom: 1px solid #e0e0e0;
        background: #ffffff;
        flex-shrink: 0;
    }

    .top-bar-left {
        flex: 1;
    }

    .top-bar-center {
        flex: 1;
        display: flex;
        justify-content: center;
    }

    .top-bar-right {
        flex: 1;
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        align-items: center;
    }

    .document-title {
        font-size: 18px;
        font-weight: 500;
        color: #000;
    }

    .dropdown-container {
        position: relative;
        display: inline-block;
    }

    .dropdown-btn {
        padding: 8px 12px;
        background: #ffffff;
        border: 1px solid #d0d0d0;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        color: #000;
        transition: all 0.2s;
        position: relative;
        display: flex;
        align-items: center;
        gap: 6px;
        white-space: nowrap;
    }

    .dropdown-btn:hover {
        border-color: #000;
        background: #f5f5f5;
    }

    .dropdown-btn.active {
        border-color: #000;
        background: #f5f5f5;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        right: 0;
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 1000;
        margin-top: 4px;
        min-width: 280px;
    }

    .dropdown-menu.active {
        display: block;
    }

    .dropdown-container:hover .dropdown-menu {
        display: block;
    }

    .dropdown-container:hover .dropdown-btn {
        border-color: #000;
        background: #f5f5f5;
    }

    .dropdown-menu-header {
        padding: 12px 16px;
        border-bottom: 1px solid #e0e0e0;
        font-weight: 500;
        font-size: 13px;
        color: #000;
    }

    .dropdown-menu-content {
        padding: 12px 16px;
        max-height: 300px;
        overflow-y: auto;
    }

    .file-option-btn {
        display: block;
        width: 100%;
        padding: 10px 8px;
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 3px;
        cursor: pointer;
        font-size: 13px;
        color: #000;
        text-align: left;
        transition: all 0.2s;
    }

    .file-option-btn:hover {
        border-color: #d0d0d0;
        background: #f9f9f9;
    }

    .file-list-container {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .file-item-btn {
        display: block;
        width: 100%;
        padding: 10px 8px;
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 3px;
        cursor: pointer;
        font-size: 13px;
        color: #000;
        text-align: left;
        transition: all 0.2s;
    }

    .file-item-btn:hover {
        border-color: #d0d0d0;
        background: #f9f9f9;
    }

    .share-form {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .share-input {
        padding: 8px 12px;
        border: 1px solid #d0d0d0;
        border-radius: 4px;
        font-size: 13px;
        background: #ffffff;
        color: #333;
    }

    .share-input:focus {
        outline: none;
        border-color: #000;
    }

    .share-invite-btn {
        padding: 8px 12px;
        background: #ffffff;
        border: 1px solid #000;
        color: #000;
        border-radius: 4px;
        cursor: pointer;
        font-size: 13px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .share-invite-btn:hover {
        background: #f5f5f5;
    }

    .version-list-dropdown {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .version-item-dropdown {
        padding: 10px 12px;
        border: 1px solid #e0e0e0;
        border-radius: 3px;
        background: #ffffff;
        transition: all 0.2s;
        font-size: 13px;
    }

    .version-item-dropdown:hover {
        border-color: #d0d0d0;
        background: #f9f9f9;
    }

    .version-time-dropdown {
        font-weight: 500;
        color: #000;
        margin-bottom: 4px;
    }

    .version-author-dropdown {
        font-size: 12px;
        color: #999;
        margin-bottom: 6px;
    }

    .version-view-btn {
        padding: 5px 10px;
        background: #ffffff;
        border: 1px solid #d0d0d0;
        border-radius: 3px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 500;
        color: #000;
        transition: all 0.2s;
    }

    .version-view-btn:hover {
        border-color: #000;
        background: #f5f5f5;
    }

    .login-btn {
        padding: 8px 16px;
        background: #ffffff;
        border: 1px solid #000;
        color: #000;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .login-btn:hover {
        background: #f5f5f5;
    }

    .editor-area {
        flex: 1;
        display: flex;
        flex-direction: column;
        padding: 24px;
        min-height: 85vh;
    }

    .editor-textarea {
        width: 100%;
        min-height: 1000px;
        padding: 16px;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        font-size: 15px;
        line-height: 1.5;
        color: #333;
        background: #ffffff;
        resize: vertical;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
        height: 363px;
    }

    .editor-textarea:focus {
        border-color: #000;
        box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.05);
    }

    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 16px;
        background: #fff;
        border: 1px solid #000;
        border-radius: 4px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        font-size: 13px;
        animation: slideIn 0.3s ease-out;
        z-index: 1001;
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(400px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        z-index: 2000;
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        width: 90%;
        max-width: 500px;
        max-height: 400px;
        overflow-y: auto;
        box-shadow: 0 8px 24px rgba(0,0,0,0.2);
    }

    .modal-header {
        padding: 16px;
        border-bottom: 1px solid #e0e0e0;
        font-weight: 500;
        font-size: 15px;
    }

    .modal-body {
        padding: 16px;
    }

    .modal-footer {
        padding: 16px;
        border-top: 1px solid #e0e0e0;
        display: flex;
        gap: 8px;
        justify-content: flex-end;
    }

    .modal-cancel-btn {
        padding: 8px 16px;
        background: #ffffff;
        border: 1px solid #d0d0d0;
        border-radius: 4px;
        cursor: pointer;
        font-size: 13px;
    }

    .modal-cancel-btn:hover {
        border-color: #000;
        background: #f5f5f5;
    }

    .dropdown-menu::-webkit-scrollbar {
        width: 6px;
    }

    .dropdown-menu::-webkit-scrollbar-track {
        background: transparent;
    }

    .dropdown-menu::-webkit-scrollbar-thumb {
        background: #d0d0d0;
        border-radius: 3px;
    }

    .dropdown-menu::-webkit-scrollbar-thumb:hover {
        background: #999;
    }

    @media (max-width: 768px) {
        .top-bar {
            flex-direction: column;
            gap: 12px;
            align-items: stretch;
        }

        .top-bar-left,
        .top-bar-center,
        .top-bar-right {
            width: 100%;
            flex: none;
        }

        .top-bar-center {
            justify-content: flex-start;
        }

        .top-bar-right {
            justify-content: flex-start;
            gap: 8px;
            flex-wrap: wrap;
        }

        .dropdown-menu {
            right: auto;
            left: 0;
        }

        .editor-area {
            padding: 16px;
        }
    }
</style>

<input type="file" id="fileInput" style="display: none;" onchange="handleFileSelect(event)" />

<div class="editor-container">
    <div class="top-bar">
        <div class="top-bar-left">
            <div class="dropdown-container">
                <button class="dropdown-btn" id="fileBtn">
                    File
                </button>
                <div class="dropdown-menu" id="fileDropdown" style="left: 0; right: auto;">
                    <div class="dropdown-menu-content">
                        <div style="display: flex; flex-direction: column; gap: 4px;">
                            <button class="file-option-btn" onclick="newDocument()">New</button>
                            <button class="file-option-btn" onclick="openDocumentClick()">Open</button>
                            <button class="file-option-btn" onclick="saveDocument()">Save</button>
                            <button class="file-option-btn" onclick="downloadDocument()">Download</button>
                            <button class="file-option-btn" onclick="closeDocument()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="top-bar-center">
            <div class="document-title">Untitled Document</div>
        </div>

        <div class="top-bar-right">
            <div class="dropdown-container">
                <button class="dropdown-btn" id="versionBtn">
                    Version History
                </button>
                <div class="dropdown-menu" id="versionDropdown">
                    <div class="dropdown-menu-header">Document Versions</div>
                    <div class="dropdown-menu-content">
                        <div class="version-list-dropdown" id="versionListDropdown">
                            <div class="version-item-dropdown">
                                <div class="version-time-dropdown">Today at 2:45 PM</div>
                                <div class="version-author-dropdown">by You</div>
                                <button class="version-view-btn" onclick="viewVersion(1)">View</button>
                            </div>
                            <div class="version-item-dropdown">
                                <div class="version-time-dropdown">Today at 1:30 PM</div>
                                <div class="version-author-dropdown">by You</div>
                                <button class="version-view-btn" onclick="viewVersion(2)">View</button>
                            </div>
                            <div class="version-item-dropdown">
                                <div class="version-time-dropdown">Yesterday at 4:15 PM</div>
                                <div class="version-author-dropdown">by You</div>
                                <button class="version-view-btn" onclick="viewVersion(3)">View</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="dropdown-container">
                <button class="dropdown-btn" id="shareBtn">
                    Share
                </button>
                <div class="dropdown-menu" id="shareDropdown">
                    <div class="dropdown-menu-header">Invite Collaborators</div>
                    <div class="dropdown-menu-content">
                        <div class="share-form">
                            <input type="email" class="share-input" id="emailInput" placeholder="Enter email address" />
                            <button class="share-invite-btn" onclick="inviteCollaborator()">Invite</button>
                        </div>
                    </div>
                </div>
            </div>

            <button class="login-btn" onclick="login()">Login</button>
        </div>
    </div>

    <div class="editor-area">
        <textarea 
            class="editor-textarea" 
            id="docEditor" 
            placeholder="Start typing here..."
            spellcheck="false"
        ></textarea>
    </div>
</div>



<script>
    document.addEventListener('click', (e) => {
        if (!e.target.closest('[id$="Dropdown"], [id$="Btn"]')) {
            document.getElementById('versionDropdown').classList.remove('active');
            document.getElementById('shareDropdown').classList.remove('active');
            document.getElementById('fileDropdown').classList.remove('active');
            document.getElementById('versionBtn').classList.remove('active');
            document.getElementById('shareBtn').classList.remove('active');
            document.getElementById('fileBtn').classList.remove('active');
        }
    });

    function toggleVersionDropdown() {
        const dropdown = document.getElementById('versionDropdown');
        const btn = document.getElementById('versionBtn');
        const shareDropdown = document.getElementById('shareDropdown');
        const shareBtn = document.getElementById('shareBtn');
        const fileDropdown = document.getElementById('fileDropdown');
        const fileBtn = document.getElementById('fileBtn');

        const isOpen = dropdown.classList.contains('active');

        dropdown.classList.toggle('active');
        btn.classList.toggle('active');

        if (!isOpen) {
            shareDropdown.classList.remove('active');
            shareBtn.classList.remove('active');
            fileDropdown.classList.remove('active');
            fileBtn.classList.remove('active');
        }
    }

    function toggleShareDropdown() {
        const dropdown = document.getElementById('shareDropdown');
        const btn = document.getElementById('shareBtn');
        const versionDropdown = document.getElementById('versionDropdown');
        const versionBtn = document.getElementById('versionBtn');
        const fileDropdown = document.getElementById('fileDropdown');
        const fileBtn = document.getElementById('fileBtn');

        const isOpen = dropdown.classList.contains('active');

        dropdown.classList.toggle('active');
        btn.classList.toggle('active');

        if (!isOpen) {
            versionDropdown.classList.remove('active');
            versionBtn.classList.remove('active');
            fileDropdown.classList.remove('active');
            fileBtn.classList.remove('active');
        }
    }

    function toggleFileDropdown() {
        const dropdown = document.getElementById('fileDropdown');
        const btn = document.getElementById('fileBtn');
        const shareDropdown = document.getElementById('shareDropdown');
        const shareBtn = document.getElementById('shareBtn');
        const versionDropdown = document.getElementById('versionDropdown');
        const versionBtn = document.getElementById('versionBtn');

        const isOpen = dropdown.classList.contains('active');

        dropdown.classList.toggle('active');
        btn.classList.toggle('active');

        if (!isOpen) {
            shareDropdown.classList.remove('active');
            shareBtn.classList.remove('active');
            versionDropdown.classList.remove('active');
            versionBtn.classList.remove('active');
        }
    }

    function inviteCollaborator() {
        const emailInput = document.getElementById('emailInput');
        const email = emailInput.value.trim();

        if (!email) {
            showNotification('Please enter an email address');
            return;
        }

        if (!isValidEmail(email)) {
            showNotification('Invalid email address');
            return;
        }

        showNotification('Invitation sent to ' + email);
        emailInput.value = '';
    }

    function viewVersion(versionId) {
        showNotification('Loading version ' + versionId);
    }

    function login() {
        showNotification('Login functionality coming soon');
    }

    function newDocument() {
        showNotification('Creating new document');
        document.getElementById('fileDropdown').classList.remove('active');
        document.getElementById('fileBtn').classList.remove('active');
    }

    function openDocumentClick() {
        document.getElementById('fileInput').click();
        document.getElementById('fileDropdown').classList.remove('active');
        document.getElementById('fileBtn').classList.remove('active');
    }

    function handleFileSelect(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('docEditor').value = e.target.result;
            document.querySelector('.document-title').textContent = file.name;
            showNotification('Opened ' + file.name);
        };
        reader.readAsText(file);
        
        event.target.value = '';
    }

    function saveDocument() {
        showNotification('Document saved');
        document.getElementById('fileDropdown').classList.remove('active');
        document.getElementById('fileBtn').classList.remove('active');
    }

    function downloadDocument() {
        showNotification('Downloading document');
        document.getElementById('fileDropdown').classList.remove('active');
        document.getElementById('fileBtn').classList.remove('active');
    }

    function closeDocument() {
        showNotification('Closing document');
        document.getElementById('fileDropdown').classList.remove('active');
        document.getElementById('fileBtn').classList.remove('active');
    }

    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function showNotification(message) {
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-out forwards';
            setTimeout(() => notification.remove(), 300);
        }, 2500);
    }

    document.getElementById('emailInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            inviteCollaborator();
        }
    });

    let autoSaveTimeout;
    document.getElementById('docEditor').addEventListener('input', () => {
        clearTimeout(autoSaveTimeout);
        autoSaveTimeout = setTimeout(() => {
            showNotification('Document saved');
        }, 2000);
    });


</script>

</asp:Content>
