import tkinter as tk
from tkinter import ttk, messagebox
import clips
import os


class OutfitCoordinatorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Smart Outfit Coordinator")
        self.root.geometry("1050x750") 
        self.root.configure(bg="#f4f6f9")
        self.root.resizable(True, True)

        # ====================== CLIPS Environment ======================
        self.env = clips.Environment()
        self.load_clips_files()

        # ====================== UI Styling ======================
        self.style = ttk.Style()
        self.style.theme_use("clam")
        self.style.configure("TLabel", background="#f4f6f9", font=("Segoe UI", 10))
        self.style.configure("TFrame", background="#f4f6f9")
        self.style.configure("Header.TLabel", font=("Segoe UI", 18, "bold"), foreground="#1e293b")
        self.style.configure("Action.TButton", font=("Segoe UI", 12, "bold"), background="#2563eb", foreground="white")
        self.style.map("Action.TButton", background=[("active", "#1d4ed8")])

        # Header
        title_frame = ttk.Frame(self.root)
        title_frame.pack(pady=20, fill="x", padx=20)
        ttk.Label(title_frame, text="Smart Outfit Coordinator", style="Header.TLabel").pack(anchor="w")
        ttk.Label(title_frame, text="Select a clothing item and its details to get smart recommendations", 
                  foreground="#64748b").pack(anchor="w")

        # Main Container
        main_container = ttk.Frame(self.root)
        main_container.pack(fill="both", expand=True, padx=20, pady=10)

        # ==================== Left Panel - Input ====================
        input_frame = ttk.LabelFrame(main_container, text=" User Inputs ", padding=20)
        input_frame.pack(side="left", fill="both", expand=False, padx=(0, 15), pady=10)

        items = ["Shirt", "T-shirt", "Jacket", "Pants", "Skirt", "Shorts", "Shoes", 
                 "Sneakers", "Heels", "Flats", "Dress", "Hats", "Bags"]
        colors = ["black", "white", "grey", "beige", "navy", "red", "yellow", "orange", 
                  "pink", "burgundy", "blue", "green", "olive", "purple", "light-blue"]
        seasons = ["winter", "autumn", "summer", "spring"]
        occasions = ["formal", "casual"]
        genders = ["male", "female"]

        # Comboboxes
        self.create_combobox(input_frame, "Current Item Type:", items, 0)
        self.create_combobox(input_frame, "Main Color:", colors, 0)
        self.create_combobox(input_frame, "Season:", seasons, 2)
        self.create_combobox(input_frame, "Occasion Type:", occasions, 1)
        self.create_combobox(input_frame, "Gender:", genders, 1) 

        # Buttons Frame
        btn_frame = ttk.Frame(input_frame)
        btn_frame.pack(fill="x", pady=20)

        self.btn_generate = ttk.Button(btn_frame, text="Run", 
                                       style="Action.TButton", command=self.process_inference)
        self.btn_generate.pack(side="left", fill="x", expand=True, padx=(0, 5))

        self.btn_clear = ttk.Button(btn_frame, text="Clear Results", 
                                    command=self.clear_results)
        self.btn_clear.pack(side="right", fill="x", expand=True, padx=(5, 0))

        # ==================== Right Panel - Results ====================
        result_frame = ttk.LabelFrame(main_container, text=" Recommendation Results ", padding=15)
        result_frame.pack(side="right", fill="both", expand=True, pady=10)

        # Setup columns
        columns = ("item", "suggested_colors", "avoided_colors")
        self.tree = ttk.Treeview(result_frame, columns=columns, show="headings", height=22)
        
        self.tree.heading("item", text="Suggested Item")
        self.tree.heading("suggested_colors", text="Suggested Colors")
        self.tree.heading("avoided_colors", text="Colors to Avoid")

        # Distribute width to fit the 3 columns
        self.tree.column("item", width=140, anchor="center")
        self.tree.column("suggested_colors", width=320, anchor="w")
        self.tree.column("avoided_colors", width=320, anchor="w")

        scrollbar = ttk.Scrollbar(result_frame, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=scrollbar.set)

        self.tree.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

    def create_combobox(self, parent, label_text, values, default_index):
        ttk.Label(parent, text=label_text).pack(anchor="w", pady=(10, 2))
        cb = ttk.Combobox(parent, values=values, state="readonly", width=32, font=("Segoe UI", 10))
        cb.pack(fill="x", pady=(0, 12))
        cb.set(values[default_index])
        
        # Save references based on the English labels
        if "Item" in label_text:
            self.cb_item = cb
        elif "Color" in label_text:
            self.cb_color = cb
        elif "Season" in label_text:
            self.cb_weather = cb
        elif "Occasion" in label_text:
            self.cb_occasion = cb
        elif "Gender" in label_text: 
            self.cb_gender = cb
            
        return cb

    def load_clips_files(self):
        """Load files in the correct order"""
        try:
            script_dir = os.path.dirname(os.path.abspath(__file__))
            
            facts_path = os.path.join(script_dir, "clothing_facts.clp")
            kb_path = os.path.join(script_dir, "knowledge_base.clp")

            if not os.path.exists(facts_path):
                messagebox.showerror("Error", f"File not found:\n{facts_path}")
                return
            if not os.path.exists(kb_path):
                messagebox.showerror("Error", f"File not found:\n{kb_path}")
                return

            self.env.load(facts_path)   
            self.env.load(kb_path)    

            print("✅ Files loaded successfully")
            
        except Exception as e:
            messagebox.showerror("CLIPS Loading Error", f"Failed to load files:\n{str(e)}")

    def process_inference(self):
        """Run inference and display grouped results (suggestions and avoidances)"""
        self.clear_results()

        try:
            self.env.reset()

           
            user_item = self.cb_item.get()
            user_color = self.cb_color.get()
            user_weather = self.cb_weather.get()
            user_occasion = self.cb_occasion.get()
            user_gender = self.cb_gender.get() 

           
            fact_string = f"""
            (user-input 
                (item-type {user_item}) 
                (color {user_color}) 
                (weather {user_weather}) 
                (occasion {user_occasion})
                (gender {user_gender}))
            """

            self.env.assert_string(fact_string)
            self.env.run()

            # Extract recommendations from CLIPS environment
            recommendations = [f for f in self.env.facts() if f.template.name == "recommendation"]

            if not recommendations:
                messagebox.showinfo("Inference Result", "No suitable recommendations found for this input.")
                return

            # --- Core step: Group colors for each item in a dictionary to prevent duplicates ---
            grouped_data = {}
            for fact in recommendations:
                try:
                    rec_type = str(fact['rec-type']).strip('"')
                    item = str(fact['suggested-item'])
                    color = str(fact['suggested-color'])
                except KeyError:
                    continue
                
                # Create a new record for the item if it doesn't exist yet
                if item not in grouped_data:
                    grouped_data[item] = {'suggest': set(), 'avoid': set()}
                
                # Sort the color by recommendation type
                
                if rec_type in ["perfect", "good", "suggest"]: 
                    grouped_data[item]['suggest'].add(color)
                elif rec_type == "avoid":
                    grouped_data[item]['avoid'].add(color)

            # --- Insert the grouped data into the Treeview ---
            for item, data in grouped_data.items():
                suggested_str = ", ".join(sorted(data['suggest'])) if data['suggest'] else "None"
                avoided_str = ", ".join(sorted(data['avoid'])) if data['avoid'] else "None"
                
               
                if suggested_str != "None" or avoided_str != "None":
                    self.tree.insert("", "end", values=(
                        item,
                        suggested_str,
                        avoided_str
                    ))

        except Exception as e:
            messagebox.showerror("Error during inference", f"An error occurred: {str(e)}")

    def clear_results(self):
        """Clear all results from the table"""
        for row in self.tree.get_children():
            self.tree.delete(row)


if __name__ == "__main__":
    root = tk.Tk()
    app = OutfitCoordinatorApp(root)
    root.mainloop()