/* ==========================================================================
   JAVASCRIPT: TƯƠNG TÁC GIAO DIỆN FACEBOOK SIMPLIFIED
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Chuyển đổi Navigation Tab trên Fixed Header
    const navTabs = document.querySelectorAll('.nav-tab');
    navTabs.forEach(tab => {
        tab.addEventListener('click', (e) => {
            e.preventDefault();
            navTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            const tabName = tab.getAttribute('title');
            showToast(`Đang chuyển sang tab: ${tabName}`);
        });
    });

    // 2. Xử lý ô nhập đăng bài viết (Enable / Disable nút Đăng)
    const postInput = document.getElementById('post-input');
    const btnSubmitPost = document.getElementById('btn-submit-post');
    const postsContainer = document.getElementById('posts-container');

    if (postInput && btnSubmitPost) {
        postInput.addEventListener('input', () => {
            if (postInput.value.trim().length > 0) {
                btnSubmitPost.removeAttribute('disabled');
            } else {
                btnSubmitPost.setAttribute('disabled', 'true');
            }
        });

        // Bấm nút Đăng bài
        btnSubmitPost.addEventListener('click', () => {
            createPost(postInput.value.trim());
            postInput.value = '';
            btnSubmitPost.setAttribute('disabled', 'true');
        });

        // Nhấn Enter trong ô đăng bài
        postInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && postInput.value.trim().length > 0) {
                createPost(postInput.value.trim());
                postInput.value = '';
                btnSubmitPost.setAttribute('disabled', 'true');
            }
        });
    }

    // 3. Nút "Xem thêm / Thu gọn" ở Left Sidebar
    const seeMoreBtn = document.getElementById('see-more-left');
    if (seeMoreBtn) {
        let isExpanded = false;
        seeMoreBtn.addEventListener('click', () => {
            isExpanded = !isExpanded;
            const textSpan = seeMoreBtn.querySelector('.item-text');
            const icon = seeMoreBtn.querySelector('i');
            if (isExpanded) {
                textSpan.textContent = 'Ẩn bớt';
                icon.className = 'fa-solid fa-chevron-up';
                showToast('Đã mở rộng danh mục chức năng');
            } else {
                textSpan.textContent = 'Xem thêm';
                icon.className = 'fa-solid fa-chevron-down';
            }
        });
    }
});

// Hàm tạo bài viết mới đưa lên đầu danh sách feed
function createPost(content) {
    if (!content) return;

    const postsContainer = document.getElementById('posts-container');
    const newPostId = Date.now();

    const postArticle = document.createElement('article');
    postArticle.className = 'card post-card';
    postArticle.setAttribute('data-post-id', newPostId);

    postArticle.innerHTML = `
        <div class="post-header">
            <div class="post-author-info">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Avatar" class="avatar-md">
                <div>
                    <a href="#" class="author-name">Lương Thị Giang</a>
                    <div class="post-meta">
                        <span>Vừa xong</span>
                        <span class="dot-separator">·</span>
                        <i class="fa-solid fa-earth-americas" title="Công khai"></i>
                    </div>
                </div>
            </div>
            <div class="post-options-btn">
                <i class="fa-solid fa-ellipsis"></i>
            </div>
        </div>

        <div class="post-body">
            <p class="post-text">${escapeHTML(content)}</p>
        </div>

        <div class="post-stats">
            <div class="reactions-count">
                <span class="reaction-icons">
                    <span class="icon-like"><i class="fa-solid fa-thumbs-up"></i></span>
                </span>
                <span class="stats-text like-count-text">1 người khác</span>
            </div>
            <div class="comments-shares-count">
                <span>0 bình luận</span>
            </div>
        </div>

        <div class="post-actions">
            <button class="action-btn like-btn" onclick="toggleLike(this, ${newPostId})">
                <i class="fa-regular fa-thumbs-up"></i>
                <span>Thích</span>
            </button>
            <button class="action-btn comment-btn" onclick="focusComment(${newPostId})">
                <i class="fa-regular fa-message"></i>
                <span>Bình luận</span>
            </button>
            <button class="action-btn share-btn" onclick="showShareToast()">
                <i class="fa-solid fa-share"></i>
                <span>Chia sẻ</span>
            </button>
        </div>

        <div class="comments-section">
            <div class="comment-input-box">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Avatar" class="avatar-sm">
                <div class="comment-input-wrapper">
                    <input type="text" placeholder="Viết bình luận công khai..." class="comment-input" onkeypress="handleCommentKeypress(event, ${newPostId})">
                    <div class="comment-input-icons">
                        <i class="fa-regular fa-face-smile"></i>
                        <i class="fa-solid fa-camera"></i>
                    </div>
                </div>
            </div>
        </div>
    `;

    postsContainer.prepend(postArticle);
    showToast('🎉 Đã đăng bài viết mới thành công!');
}

// Hàm chuyển đổi Thích (Like Toggle)
function toggleLike(btnElement, postId) {
    const isLiked = btnElement.classList.contains('liked');
    const postCard = btnElement.closest('.post-card');
    const likeCountText = postCard.querySelector('.like-count-text');

    if (isLiked) {
        btnElement.classList.remove('liked');
        btnElement.querySelector('i').className = 'fa-regular fa-thumbs-up';
        if (likeCountText) {
            const currentNum = parseInt(likeCountText.textContent) || 1;
            likeCountText.textContent = `${Math.max(0, currentNum - 1)} người khác`;
        }
    } else {
        btnElement.classList.add('liked');
        btnElement.querySelector('i').className = 'fa-solid fa-thumbs-up';
        if (likeCountText) {
            const currentNum = parseInt(likeCountText.textContent) || 0;
            likeCountText.textContent = `Bạn và ${currentNum} người khác`;
        }
        showToast('👍 Đã thích bài viết');
    }
}

// Focus vào ô bình luận
function focusComment(postId) {
    const postCard = document.querySelector(`.post-card[data-post-id="${postId}"]`);
    if (postCard) {
        const commentInput = postCard.querySelector('.comment-input');
        if (commentInput) {
            commentInput.focus();
        }
    }
}

// Xử lý gửi bình luận khi nhấn Enter
function handleCommentKeypress(event, postId) {
    if (event.key === 'Enter' && event.target.value.trim() !== '') {
        const commentText = event.target.value.trim();
        const postCard = document.querySelector(`.post-card[data-post-id="${postId}"]`);
        const commentsSection = postCard.querySelector('.comments-section');
        const commentInputBox = postCard.querySelector('.comment-input-box');

        const newCommentItem = document.createElement('div');
        newCommentItem.className = 'comment-item';
        newCommentItem.innerHTML = `
            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Avatar" class="avatar-sm">
            <div class="comment-content-wrap">
                <div class="comment-bubble">
                    <span class="comment-author">Lương Thị Giang</span>
                    <p class="comment-text">${escapeHTML(commentText)}</p>
                </div>
                <div class="comment-actions">
                    <span>Thích</span> · <span>Phản hồi</span> · <span class="comment-time">Vừa xong</span>
                </div>
            </div>
        `;

        commentsSection.insertBefore(newCommentItem, commentInputBox);
        event.target.value = '';
        showToast('💬 Đã gửi bình luận');
    }
}

// Toast thông báo
let toastTimeout;
function showToast(message) {
    const toast = document.getElementById('fb-toast');
    const toastMsg = document.getElementById('toast-msg');
    if (!toast || !toastMsg) return;

    toastMsg.textContent = message;
    toast.classList.add('show');

    clearTimeout(toastTimeout);
    toastTimeout = setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

function showShareToast() {
    showToast('🚀 Đã sao chép liên kết bài viết vào clipboard!');
}

// Hàm bảo vệ chống XSS
function escapeHTML(str) {
    return str.replace(/[&<>'"]/g, 
        tag => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            "'": '&#39;',
            '"': '&quot;'
        }[tag] || tag)
    );
}
