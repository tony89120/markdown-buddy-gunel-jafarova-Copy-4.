# AI Assistance Declaration: I used ChatGPT (GPT-6, October 22, 2026) for documentation
# organization and example-code drafting. Actual prompts are recorded in Appendix.md.
# I will verify the script by running it in R and independently checking its output.
# All final calculations are done by myself. I am responsible for the accuracy and
# originality of this work.

# Synthetic Student Performance Analysis — illustrative educational script
# Data are fictional; no external files are used.
students <- data.frame(
  student_id = paste0("S", 1:6),
  study_hours = c(2, 3, 4, 5, 6, 7),
  score = c(58, 63, 70, 74, 82, 88)
)
print(students)
print(summary(students[c("study_hours", "score")]))
plot(students$study_hours, students$score,
     main = "Synthetic Study Hours and Scores",
     xlab = "Study hours", ylab = "Score (0–100)",
     pch = 19)
