#!/usr/bin/env python3
"""
kubectl Command Quiz - Daily Practice Tool for CKA Exam
Practice kubectl commands and their flags interactively
"""

import random
import json
import os
from datetime import datetime
from typing import Dict, List, Tuple

class KubectlQuiz:
    def __init__(self):
        self.questions = self.load_questions()
        self.score = 0
        self.total_questions = 0
        self.session_history = []
        
    def load_questions(self) -> List[Dict]:
        """Load kubectl command questions organized by difficulty and topic"""
        return [
            # Basic Pod Operations
            {
                "category": "Pod Management",
                "difficulty": "Basic",
                "question": "Create a pod named 'nginx-pod' using the nginx image",
                "answer": "kubectl run nginx-pod --image=nginx",
                "hints": ["Use 'kubectl run'", "Specify --image flag"],
                "explanation": "kubectl run creates a single pod. Use 'kubectl create deployment' for deployments."
            },
            {
                "category": "Pod Management",
                "difficulty": "Basic",
                "question": "Get all pods in all namespaces",
                "answer": "kubectl get pods --all-namespaces",
                "alternatives": ["kubectl get pods -A", "kubectl get po -A"],
                "hints": ["Use --all-namespaces or -A flag"],
                "explanation": "-A is shorthand for --all-namespaces"
            },
            {
                "category": "Pod Management",
                "difficulty": "Basic",
                "question": "Delete a pod named 'test-pod' forcefully without waiting",
                "answer": "kubectl delete pod test-pod --force --grace-period=0",
                "hints": ["Use --force and --grace-period=0"],
                "explanation": "--force with --grace-period=0 immediately removes the pod from the API"
            },
            {
                "category": "Pod Management",
                "difficulty": "Intermediate",
                "question": "Run a pod named 'busybox' with image busybox that sleeps for 3600 seconds",
                "answer": "kubectl run busybox --image=busybox -- sleep 3600",
                "hints": ["Use -- to separate kubectl args from container command"],
                "explanation": "Everything after -- is passed as command to the container"
            },
            {
                "category": "Pod Management",
                "difficulty": "Intermediate",
                "question": "Create a pod YAML manifest for nginx without creating it",
                "answer": "kubectl run nginx --image=nginx --dry-run=client -o yaml",
                "hints": ["Use --dry-run=client and -o yaml"],
                "explanation": "--dry-run=client simulates the command without creating resources"
            },
            
            # Deployment Operations
            {
                "category": "Deployments",
                "difficulty": "Basic",
                "question": "Create a deployment named 'webapp' with image nginx and 3 replicas",
                "answer": "kubectl create deployment webapp --image=nginx --replicas=3",
                "hints": ["Use 'kubectl create deployment'", "Add --replicas flag"],
                "explanation": "kubectl create deployment is the imperative way to create deployments"
            },
            {
                "category": "Deployments",
                "difficulty": "Basic",
                "question": "Scale deployment 'webapp' to 5 replicas",
                "answer": "kubectl scale deployment webapp --replicas=5",
                "alternatives": ["kubectl scale deploy webapp --replicas=5"],
                "hints": ["Use kubectl scale command"],
                "explanation": "kubectl scale adjusts the replica count of a deployment"
            },
            {
                "category": "Deployments",
                "difficulty": "Intermediate",
                "question": "Update the image of deployment 'webapp' container 'nginx' to 'nginx:1.20'",
                "answer": "kubectl set image deployment/webapp nginx=nginx:1.20",
                "alternatives": ["kubectl set image deploy/webapp nginx=nginx:1.20"],
                "hints": ["Use kubectl set image", "Format: container-name=new-image"],
                "explanation": "kubectl set image updates container images in a deployment"
            },
            {
                "category": "Deployments",
                "difficulty": "Intermediate",
                "question": "Check the rollout status of deployment 'webapp'",
                "answer": "kubectl rollout status deployment/webapp",
                "hints": ["Use kubectl rollout status"],
                "explanation": "Monitors the progress of a deployment rollout"
            },
            {
                "category": "Deployments",
                "difficulty": "Advanced",
                "question": "Rollback deployment 'webapp' to the previous revision",
                "answer": "kubectl rollout undo deployment/webapp",
                "hints": ["Use kubectl rollout undo"],
                "explanation": "Rolls back to the previous revision. Use --to-revision=n for specific revision"
            },
            
            # Service Operations
            {
                "category": "Services",
                "difficulty": "Basic",
                "question": "Expose deployment 'webapp' on port 80",
                "answer": "kubectl expose deployment webapp --port=80",
                "hints": ["Use kubectl expose command"],
                "explanation": "Creates a ClusterIP service by default"
            },
            {
                "category": "Services",
                "difficulty": "Intermediate",
                "question": "Create a NodePort service for deployment 'webapp' on port 80 with nodePort 30080",
                "answer": "kubectl expose deployment webapp --port=80 --type=NodePort --node-port=30080",
                "hints": ["Use --type=NodePort and --node-port"],
                "explanation": "NodePort exposes the service on each node's IP at a static port"
            },
            {
                "category": "Services",
                "difficulty": "Intermediate",
                "question": "Create a service YAML for a ClusterIP service without creating it",
                "answer": "kubectl create service clusterip my-svc --tcp=80:80 --dry-run=client -o yaml",
                "hints": ["Use kubectl create service clusterip", "Add --dry-run=client -o yaml"],
                "explanation": "Generates service YAML without creating the resource"
            },
            
            # ConfigMaps and Secrets
            {
                "category": "ConfigMaps",
                "difficulty": "Basic",
                "question": "Create a configmap named 'app-config' from literal key-value: APP_ENV=production",
                "answer": "kubectl create configmap app-config --from-literal=APP_ENV=production",
                "alternatives": ["kubectl create cm app-config --from-literal=APP_ENV=production"],
                "hints": ["Use kubectl create configmap with --from-literal"],
                "explanation": "ConfigMaps store non-sensitive configuration data"
            },
            {
                "category": "ConfigMaps",
                "difficulty": "Intermediate",
                "question": "Create a configmap named 'nginx-config' from file 'nginx.conf'",
                "answer": "kubectl create configmap nginx-config --from-file=nginx.conf",
                "hints": ["Use --from-file flag"],
                "explanation": "--from-file creates configmap from file contents"
            },
            {
                "category": "Secrets",
                "difficulty": "Basic",
                "question": "Create a generic secret named 'db-secret' with password='mypass123'",
                "answer": "kubectl create secret generic db-secret --from-literal=password=mypass123",
                "hints": ["Use kubectl create secret generic"],
                "explanation": "Generic secrets store arbitrary user-defined data"
            },
            {
                "category": "Secrets",
                "difficulty": "Intermediate",
                "question": "Create a docker-registry secret named 'regcred' for docker hub with username 'user' and password 'pass'",
                "answer": "kubectl create secret docker-registry regcred --docker-server=docker.io --docker-username=user --docker-password=pass",
                "hints": ["Use kubectl create secret docker-registry", "Need --docker-server, --docker-username, --docker-password"],
                "explanation": "Docker-registry secrets are used for pulling private images"
            },
            
            # Namespace Operations
            {
                "category": "Namespaces",
                "difficulty": "Basic",
                "question": "Create a namespace named 'development'",
                "answer": "kubectl create namespace development",
                "alternatives": ["kubectl create ns development"],
                "hints": ["Use kubectl create namespace"],
                "explanation": "Namespaces provide scope for resources"
            },
            {
                "category": "Namespaces",
                "difficulty": "Basic",
                "question": "Set the default namespace to 'production' for the current context",
                "answer": "kubectl config set-context --current --namespace=production",
                "hints": ["Use kubectl config set-context --current"],
                "explanation": "Changes the default namespace for kubectl commands"
            },
            
            # Labels and Selectors
            {
                "category": "Labels",
                "difficulty": "Basic",
                "question": "Add label 'env=prod' to pod 'nginx-pod'",
                "answer": "kubectl label pod nginx-pod env=prod",
                "hints": ["Use kubectl label command"],
                "explanation": "Labels are key-value pairs for organizing resources"
            },
            {
                "category": "Labels",
                "difficulty": "Intermediate",
                "question": "Get all pods with label 'app=web'",
                "answer": "kubectl get pods -l app=web",
                "alternatives": ["kubectl get pods --selector=app=web"],
                "hints": ["Use -l or --selector flag"],
                "explanation": "-l is shorthand for --selector"
            },
            {
                "category": "Labels",
                "difficulty": "Advanced",
                "question": "Get all pods with labels 'env=prod' AND 'tier=frontend'",
                "answer": "kubectl get pods -l env=prod,tier=frontend",
                "hints": ["Use comma to separate multiple labels in selector"],
                "explanation": "Comma acts as AND operator in label selectors"
            },
            
            # Node Operations
            {
                "category": "Nodes",
                "difficulty": "Intermediate",
                "question": "Cordon node 'worker-1' to prevent new pods from being scheduled",
                "answer": "kubectl cordon worker-1",
                "hints": ["Use kubectl cordon"],
                "explanation": "Cordon marks node as unschedulable"
            },
            {
                "category": "Nodes",
                "difficulty": "Intermediate",
                "question": "Drain node 'worker-1' for maintenance, ignoring daemonsets",
                "answer": "kubectl drain worker-1 --ignore-daemonsets",
                "hints": ["Use kubectl drain with --ignore-daemonsets"],
                "explanation": "Drain evicts pods and cordons the node"
            },
            {
                "category": "Nodes",
                "difficulty": "Advanced",
                "question": "Taint node 'worker-1' with 'gpu=true:NoSchedule'",
                "answer": "kubectl taint nodes worker-1 gpu=true:NoSchedule",
                "hints": ["Use kubectl taint nodes", "Format: key=value:effect"],
                "explanation": "Taints prevent pods from being scheduled unless they have matching tolerations"
            },
            
            # Logs and Debugging
            {
                "category": "Debugging",
                "difficulty": "Basic",
                "question": "View logs of pod 'nginx-pod'",
                "answer": "kubectl logs nginx-pod",
                "hints": ["Use kubectl logs"],
                "explanation": "kubectl logs retrieves container logs"
            },
            {
                "category": "Debugging",
                "difficulty": "Intermediate",
                "question": "View logs of previous instance of container in pod 'nginx-pod'",
                "answer": "kubectl logs nginx-pod --previous",
                "alternatives": ["kubectl logs nginx-pod -p"],
                "hints": ["Use --previous or -p flag"],
                "explanation": "Useful when a container has restarted"
            },
            {
                "category": "Debugging",
                "difficulty": "Intermediate",
                "question": "Follow/stream logs of pod 'nginx-pod'",
                "answer": "kubectl logs nginx-pod -f",
                "alternatives": ["kubectl logs nginx-pod --follow"],
                "hints": ["Use -f or --follow flag"],
                "explanation": "Continuously streams new log entries"
            },
            {
                "category": "Debugging",
                "difficulty": "Intermediate",
                "question": "Execute bash shell inside pod 'nginx-pod'",
                "answer": "kubectl exec -it nginx-pod -- /bin/bash",
                "alternatives": ["kubectl exec -it nginx-pod -- bash"],
                "hints": ["Use kubectl exec -it", "Use -- before the command"],
                "explanation": "-it provides interactive terminal"
            },
            {
                "category": "Debugging",
                "difficulty": "Advanced",
                "question": "Copy file '/tmp/data.txt' from pod 'nginx-pod' to local './data.txt'",
                "answer": "kubectl cp nginx-pod:/tmp/data.txt ./data.txt",
                "hints": ["Use kubectl cp", "Format: pod:path localpath"],
                "explanation": "kubectl cp copies files between pods and local filesystem"
            },
            
            # RBAC
            {
                "category": "RBAC",
                "difficulty": "Intermediate",
                "question": "Create a role named 'pod-reader' that can get, list, and watch pods",
                "answer": "kubectl create role pod-reader --verb=get,list,watch --resource=pods",
                "hints": ["Use kubectl create role", "Specify --verb and --resource"],
                "explanation": "Roles define permissions within a namespace"
            },
            {
                "category": "RBAC",
                "difficulty": "Intermediate",
                "question": "Create a rolebinding 'read-pods' binding role 'pod-reader' to user 'jane'",
                "answer": "kubectl create rolebinding read-pods --role=pod-reader --user=jane",
                "hints": ["Use kubectl create rolebinding"],
                "explanation": "RoleBindings grant permissions defined in a Role to users"
            },
            {
                "category": "RBAC",
                "difficulty": "Advanced",
                "question": "Check if user 'jane' can create pods in namespace 'default'",
                "answer": "kubectl auth can-i create pods --as=jane -n default",
                "hints": ["Use kubectl auth can-i", "Use --as flag to impersonate"],
                "explanation": "Tests RBAC permissions for a user"
            },
            
            # Resource Management
            {
                "category": "Resources",
                "difficulty": "Basic",
                "question": "Get CPU and memory usage of all nodes",
                "answer": "kubectl top nodes",
                "hints": ["Use kubectl top"],
                "explanation": "Requires metrics-server to be installed"
            },
            {
                "category": "Resources",
                "difficulty": "Basic",
                "question": "Get CPU and memory usage of all pods in namespace 'default'",
                "answer": "kubectl top pods -n default",
                "hints": ["Use kubectl top pods"],
                "explanation": "Shows resource consumption of pods"
            },
            {
                "category": "Resources",
                "difficulty": "Intermediate",
                "question": "Set resource requests of 100m CPU and 256Mi memory for a deployment (dry-run)",
                "answer": "kubectl set resources deployment nginx --requests=cpu=100m,memory=256Mi --dry-run=client",
                "hints": ["Use kubectl set resources", "Format: cpu=100m,memory=256Mi"],
                "explanation": "Resource requests guarantee minimum resources for containers"
            },
            
            # JSONPath and Output
            {
                "category": "Output",
                "difficulty": "Advanced",
                "question": "Get the IP addresses of all pods using jsonpath",
                "answer": "kubectl get pods -o jsonpath='{.items[*].status.podIP}'",
                "hints": ["Use -o jsonpath", "Path: .items[*].status.podIP"],
                "explanation": "JSONPath allows extracting specific fields from output"
            },
            {
                "category": "Output",
                "difficulty": "Advanced",
                "question": "Get names of all nodes using custom-columns",
                "answer": "kubectl get nodes -o custom-columns=NAME:.metadata.name",
                "hints": ["Use -o custom-columns", "Format: HEADER:jsonpath"],
                "explanation": "Custom columns format output in a table with specified fields"
            },
            {
                "category": "Output",
                "difficulty": "Intermediate",
                "question": "Get all pod names sorted by creation timestamp",
                "answer": "kubectl get pods --sort-by=.metadata.creationTimestamp",
                "hints": ["Use --sort-by flag with JSONPath"],
                "explanation": "Sorts output based on specified field"
            },
            
            # Persistent Volumes
            {
                "category": "Storage",
                "difficulty": "Basic",
                "question": "Get all persistent volumes in the cluster",
                "answer": "kubectl get pv",
                "alternatives": ["kubectl get persistentvolumes"],
                "hints": ["PV is cluster-scoped resource"],
                "explanation": "PVs are cluster-wide storage resources"
            },
            {
                "category": "Storage",
                "difficulty": "Basic",
                "question": "Get all persistent volume claims in namespace 'default'",
                "answer": "kubectl get pvc -n default",
                "alternatives": ["kubectl get persistentvolumeclaims -n default"],
                "hints": ["PVC is namespace-scoped resource"],
                "explanation": "PVCs request storage from PVs"
            },
            
            # Network Policies
            {
                "category": "Networking",
                "difficulty": "Basic",
                "question": "Get all network policies in the current namespace",
                "answer": "kubectl get networkpolicies",
                "alternatives": ["kubectl get netpol"],
                "hints": ["netpol is short for networkpolicies"],
                "explanation": "Network policies control traffic between pods"
            },
            {
                "category": "Networking",
                "difficulty": "Basic",
                "question": "Get all services in all namespaces with wide output",
                "answer": "kubectl get svc -A -o wide",
                "alternatives": ["kubectl get services --all-namespaces -o wide"],
                "hints": ["Use -A for all namespaces, -o wide for extra details"],
                "explanation": "Wide output shows additional columns like selector"
            },
            
            # Jobs and CronJobs
            {
                "category": "Jobs",
                "difficulty": "Intermediate",
                "question": "Create a job named 'pi' that runs image 'perl' with command to calculate pi",
                "answer": "kubectl create job pi --image=perl -- perl -Mbignum=bpi -wle 'print bpi(2000)'",
                "hints": ["Use kubectl create job", "Use -- for command"],
                "explanation": "Jobs run pods to completion"
            },
            {
                "category": "Jobs",
                "difficulty": "Intermediate",
                "question": "Create a cronjob 'hello' running every minute with image 'busybox' saying hello",
                "answer": "kubectl create cronjob hello --schedule='*/1 * * * *' --image=busybox -- echo hello",
                "hints": ["Use kubectl create cronjob", "Cron schedule format: */1 * * * *"],
                "explanation": "CronJobs create Jobs on a schedule"
            },
            
            # Advanced Operations
            {
                "category": "Advanced",
                "difficulty": "Advanced",
                "question": "Replace a resource by filename, deleting and recreating it",
                "answer": "kubectl replace --force -f resource.yaml",
                "hints": ["Use kubectl replace --force"],
                "explanation": "Force replace deletes and recreates the resource"
            },
            {
                "category": "Advanced",
                "difficulty": "Advanced",
                "question": "Patch deployment 'nginx' to add annotation 'description=my-app'",
                "answer": "kubectl patch deployment nginx -p '{\"metadata\":{\"annotations\":{\"description\":\"my-app\"}}}'",
                "hints": ["Use kubectl patch", "JSON patch format"],
                "explanation": "Patch allows partial updates to resources"
            },
            {
                "category": "Advanced",
                "difficulty": "Advanced",
                "question": "Port forward local port 8080 to pod 'nginx-pod' port 80",
                "answer": "kubectl port-forward nginx-pod 8080:80",
                "alternatives": ["kubectl port-forward pod/nginx-pod 8080:80"],
                "hints": ["Use kubectl port-forward", "Format: local:pod"],
                "explanation": "Forwards local port to a pod for testing"
            }
        ]
    
    def get_random_question(self, category: str = None, difficulty: str = None) -> Dict:
        """Get a random question, optionally filtered by category or difficulty"""
        filtered = self.questions
        
        if category:
            filtered = [q for q in filtered if q["category"] == category]
        if difficulty:
            filtered = [q for q in filtered if q["difficulty"] == difficulty]
        
        return random.choice(filtered) if filtered else random.choice(self.questions)
    
    def display_question(self, question: Dict) -> None:
        """Display a question to the user"""
        print(f"\n{'='*60}")
        print(f"Category: {question['category']} | Difficulty: {question['difficulty']}")
        print(f"{'='*60}")
        print(f"\nQuestion: {question['question']}")
        print(f"{'='*60}")
    
    def check_answer(self, user_answer: str, question: Dict) -> bool:
        """Check if the user's answer is correct"""
        correct_answers = [question["answer"]]
        if "alternatives" in question:
            correct_answers.extend(question["alternatives"])
        
        # Normalize answers (remove extra spaces, lowercase)
        user_normalized = " ".join(user_answer.lower().split())
        correct_normalized = [" ".join(ans.lower().split()) for ans in correct_answers]
        
        return user_normalized in correct_normalized
    
    def show_hint(self, question: Dict, hint_num: int) -> None:
        """Show a hint for the current question"""
        if "hints" in question and hint_num < len(question["hints"]):
            print(f"\nHint {hint_num + 1}: {question['hints'][hint_num]}")
        else:
            print("\nNo more hints available!")
    
    def show_explanation(self, question: Dict) -> None:
        """Show the explanation for a question"""
        print(f"\nCorrect answer: {question['answer']}")
        if "alternatives" in question:
            print(f"Alternative answers: {', '.join(question['alternatives'])}")
        print(f"Explanation: {question['explanation']}")
    
    def run_quiz(self, num_questions: int = 10, category: str = None, difficulty: str = None) -> None:
        """Run an interactive quiz session"""
        print("\n" + "="*60)
        print(" kubectl Command Quiz - CKA Exam Preparation")
        print("="*60)
        print(f"\nStarting quiz with {num_questions} questions...")
        print("Commands: 'hint' for hint, 'skip' to skip, 'quit' to exit")
        
        asked_questions = []
        
        for i in range(num_questions):
            # Get a question that hasn't been asked yet
            question = self.get_random_question(category, difficulty)
            while question in asked_questions and len(asked_questions) < len(self.questions):
                question = self.get_random_question(category, difficulty)
            asked_questions.append(question)
            
            self.display_question(question)
            
            hint_count = 0
            answered = False
            
            while not answered:
                user_input = input("\nYour answer: ").strip()
                
                if user_input.lower() == 'quit':
                    print("\nQuitting quiz...")
                    self.show_results()
                    return
                
                elif user_input.lower() == 'skip':
                    print("\nSkipping question...")
                    self.show_explanation(question)
                    self.session_history.append({
                        "question": question["question"],
                        "user_answer": "SKIPPED",
                        "correct": False
                    })
                    break
                
                elif user_input.lower() == 'hint':
                    self.show_hint(question, hint_count)
                    hint_count += 1
                
                else:
                    if self.check_answer(user_input, question):
                        print("\n✅ Correct!")
                        self.score += 1
                        self.session_history.append({
                            "question": question["question"],
                            "user_answer": user_input,
                            "correct": True
                        })
                    else:
                        print("\n❌ Incorrect!")
                        self.session_history.append({
                            "question": question["question"],
                            "user_answer": user_input,
                            "correct": False
                        })
                    
                    self.show_explanation(question)
                    answered = True
            
            self.total_questions += 1
            print(f"\nProgress: {i+1}/{num_questions} | Score: {self.score}/{self.total_questions}")
        
        self.show_results()
    
    def show_results(self) -> None:
        """Display quiz results"""
        print("\n" + "="*60)
        print(" Quiz Results")
        print("="*60)
        
        if self.total_questions > 0:
            percentage = (self.score / self.total_questions) * 100
            print(f"\nFinal Score: {self.score}/{self.total_questions} ({percentage:.1f}%)")
            
            # Show performance by category
            category_stats = {}
            for item in self.session_history:
                # Find the question to get its category
                for q in self.questions:
                    if q["question"] == item["question"]:
                        cat = q["category"]
                        if cat not in category_stats:
                            category_stats[cat] = {"correct": 0, "total": 0}
                        category_stats[cat]["total"] += 1
                        if item["correct"]:
                            category_stats[cat]["correct"] += 1
                        break
            
            if category_stats:
                print("\nPerformance by Category:")
                for cat, stats in category_stats.items():
                    cat_percentage = (stats["correct"] / stats["total"]) * 100
                    print(f"  {cat}: {stats['correct']}/{stats['total']} ({cat_percentage:.1f}%)")
            
            # Provide feedback
            if percentage >= 90:
                print("\n🏆 Excellent! You're well-prepared for the CKA exam!")
            elif percentage >= 70:
                print("\n👍 Good job! Keep practicing to improve further.")
            elif percentage >= 50:
                print("\n📚 You're making progress. Review the explanations and practice more.")
            else:
                print("\n💪 Keep practicing! Focus on understanding the command structure.")
    
    def list_categories(self) -> None:
        """List all available categories"""
        categories = list(set(q["category"] for q in self.questions))
        print("\nAvailable Categories:")
        for i, cat in enumerate(sorted(categories), 1):
            count = len([q for q in self.questions if q["category"] == cat])
            print(f"  {i}. {cat} ({count} questions)")
    
    def list_difficulties(self) -> None:
        """List all difficulty levels"""
        difficulties = list(set(q["difficulty"] for q in self.questions))
        print("\nDifficulty Levels:")
        for diff in ["Basic", "Intermediate", "Advanced"]:
            if diff in difficulties:
                count = len([q for q in self.questions if q["difficulty"] == diff])
                print(f"  - {diff} ({count} questions)")

def main():
    """Main function to run the quiz"""
    quiz = KubectlQuiz()
    
    while True:
        print("\n" + "="*60)
        print(" kubectl Command Quiz - Main Menu")
        print("="*60)
        print("\n1. Quick Quiz (10 random questions)")
        print("2. Category Quiz (choose a category)")
        print("3. Difficulty Quiz (choose difficulty)")
        print("4. Full Quiz (all questions)")
        print("5. List Categories")
        print("6. List Difficulties")
        print("7. Custom Quiz (set number of questions)")
        print("8. Exit")
        
        choice = input("\nSelect option (1-8): ").strip()
        
        if choice == "1":
            quiz = KubectlQuiz()  # Reset scores
            quiz.run_quiz(10)
        
        elif choice == "2":
            quiz.list_categories()
            cat = input("\nEnter category name: ").strip()
            num = input("Number of questions (default 10): ").strip()
            num = int(num) if num.isdigit() else 10
            quiz = KubectlQuiz()
            quiz.run_quiz(num, category=cat)
        
        elif choice == "3":
            quiz.list_difficulties()
            diff = input("\nEnter difficulty (Basic/Intermediate/Advanced): ").strip()
            num = input("Number of questions (default 10): ").strip()
            num = int(num) if num.isdigit() else 10
            quiz = KubectlQuiz()
            quiz.run_quiz(num, difficulty=diff)
        
        elif choice == "4":
            quiz = KubectlQuiz()
            quiz.run_quiz(len(quiz.questions))
        
        elif choice == "5":
            quiz.list_categories()
            input("\nPress Enter to continue...")
        
        elif choice == "6":
            quiz.list_difficulties()
            input("\nPress Enter to continue...")
        
        elif choice == "7":
            num = input("\nNumber of questions: ").strip()
            if num.isdigit():
                quiz = KubectlQuiz()
                quiz.run_quiz(int(num))
            else:
                print("Invalid number!")
        
        elif choice == "8":
            print("\nGood luck with your CKA exam preparation! 🚀")
            break
        
        else:
            print("\nInvalid option! Please try again.")

if __name__ == "__main__":
    main()
